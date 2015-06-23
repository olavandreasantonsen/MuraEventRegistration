<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>

<cfif isDefined("URL.EventID") and isDefined("URL.AutomaticPost")>
	<cfoutput>
	<cfscript>
		import plugins.EventRegistration.library.FacebookSDK.sdk.FacebookApp;
		import plugins.EventRegistration.library.FacebookSDK.sdk.FacebookGraphAPI;

		userID = 0;

		if (Session.UserSuppliedInfo.FB.AppID is "" or Session.UserSuppliedInfo.FB.AppSecretKey is "") {
		} else {
			// Create facebookApp instance
			facebookApp = new FacebookApp(appId=Session.UserSuppliedInfo.FB.AppID, secretKey=Session.UserSuppliedInfo.FB.AppSecretKey);

			userId = facebookApp.getUserId();
			if (userId) {
				try {
					userAccessToken = facebookApp.getUserAccessToken();
					facebookGraphAPI = new FacebookGraphAPI(accessToken=userAccessToken, appId=Session.UserSuppliedInfo.FB.AppID);
					pageAccessToken = FacebookGraphAPI.getPageAccessToken(Session.UserSuppliedInfo.FB.PageID);
					facebookPageGraphAPI = new FacebookGraphAPI(accessToken=pageAccessToken, appId=Session.UserSuppliedInfo.FB.AppID);
					userObject = FacebookGraphAPI.getObject(id=userId);
					userFriends = FacebookGraphAPI.getConnections(id=userId, type='taggable_friends', limit=10);
					authenticated = true;
				} catch (any exception) {
					// Usually an invalid session (OAuthInvalidTokenException), for example if the user logged out from facebook.com
					userId = 0;
					facebookGraphAPI = new FacebookGraphAPI();
				}
			} else {
				facebookGraphAPI = new FacebookGraphAPI();
			}
			if (userId eq 0) {
				parameters = {scope=Session.UserSuppliedInfo.FB.AppScope};
				loginUrl = facebookApp.getLoginUrl(parameters);
			};
		}
	</cfscript>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Publish Event to Facebook: #Session.UserSuppliedInfo.ShortTitle#</h3>
		</div>
		<div class="art-blockcontent">
			<div id="fb-root"></div>
			<script>
				window.fbAsyncInit = function() {
					FB.init({
						appId   : '#facebookApp.getAppId()#',
						cookie  : true, // enable cookies to allow the server to access the session
						oauth	  : true, // OAuth 2.0
						status  : false, // check login status
						xfbml   : true // parse XFBML
					});
					FB.Canvas.setSize({height:1800});
				};
				(function() {
					var e = document.createElement('script');
					e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
					e.async = true;
					document.getElementById('fb-root').appendChild(e);
				}());
				<cfif userId eq 0>
					function addLoginListener() {
						// whenever the user install the app or login, we refresh the page
						FB.Event.subscribe('auth.login', function(response) {
							window.location.reload();
						});
					}
					function login() {
						FB.login(function(response) {
							if (response.authResponse) {
								// user successfully authenticated in
								window.location.reload();
							} else {
								WriteDump(response.authResponse);
								// user cancelled login
							}
						}, {scope:'#Session.UserSuppliedInfo.FB.AppScope#'});
					}
				</cfif>
			</script>
			<cfif userId eq 0>
				<div class="alert-box notice">Please complete this form to send a message to those who have registered for this event.</div>
				<hr>
				<h2 align="center">Login To Facebook</h2>
				<div class="alert-box">Please click the Login To Facebook Link Below to allow this website the ability to publish this newly created event to the Organization's Facebook Page.<br>
					<br /><br /><a href="javascript:login()" class="art-button">Login To Facebook</a>
			    </div>
				<hr />
			<cfelse>
				<cfset FBMessagePost = "On " & #DateFormat(Session.UserSuppliedInfo.EventDate, "full")# & " we will be hosting an event titled " & #Session.UserSuppliedInfo.ShortTitle# & "." & " This event will be held at " & #Session.UserSuppliedInfo.FacilityInfo.FacilityName# & " (" & #Session.UserSuppliedInfo.FacilityInfo.PhysicalAddress# & " " & #Session.UserSuppliedInfo.FacilityInfo.PhysicalCity# & ", " & #Session.UserSuppliedInfo.FacilityInfo.PhysicalState# & " " & #Session.UserSuppliedInfo.FacilityInfo.PhysicalZipCode# & "). " & " For more information and to register for this event, please visit our Event Registration System.">
				<cfset FBMessageRegLink = "http://" & #cgi.server_name# & "/plugins/EventRegistration/?EventRegistrationaction=public:events.eventinfo&EventID=#URL.EventID#">
				<cfscript>
					FBMsg = facebookPageGraphAPI.publishLink(profileId=Session.UserSuppliedInfo.FB.PageID, link="#Variables.FBMessageRegLink#", message='#Variables.FBMessagePost#');
				</cfscript>
				<cfif FBMsg CONTAINS "172096152818693_">
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.default&UserAction=PostToFB&Successful=True" addtoken="false">
				<cfelseif isNumeric(FBMsg)>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.default&UserAction=PostToFB&Successful=True" addtoken="false">
				<cfelse>
					<div class="alert-box error">An error has occurred in posting this event to the organization's Facebook Page.</div>
				</cfif>
			</cfif>
		</div>
	</div>
	</cfoutput>
<cfelse>
	<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
	<cflock timeout="60" scope="SESSION" type="Exclusive">
		<cfset Session.FormData = #StructNew()#>
		<cfif not isDefined("Session.FormErrors")><cfset Session.FormErrors = #ArrayNew()#></cfif>
	</cflock>

	<cfscript>
		timeConfig = structNew();
		timeConfig['show24Hours'] = false;
		timeConfig['showSeconds'] = false;
	</cfscript>

	<cfoutput>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Publish Event to Facebook: #Session.UserSuppliedInfo.ShortTitle#</h3>
		</div>
		<div class="art-blockcontent">
			<div class="alert-box notice">Please complete this form to send a message to those who have registered for this event.<br><Strong>Number of Registrations Currently: #Session.EventNumberRegistrations#</Strong></div>
			<hr>
			<cfif not StructKeyExists(Session.UserSuppliedInfo, "FBPost")>
			<uForm:form action="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.publishtofb&compactDisplay=false&EventID=#URL.EventID#" method="Post" id="EmailEventParticipants" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
				submitValue="Preview Facebook Posting" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="PerformAction" value="FacebookAuthenticate">
				<uForm:fieldset legend="Event Date and Time">
					<uform:field label="Primary Event Date" name="EventDate" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, First Date if event has multiple dates." />
					<cfif Session.UserSuppliedInfo.PickedEvent.EventSpanDates EQ 1>
						<uform:field label="Second Event Date" name="EventDate1" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate1, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Second Date if event has multiple dates." />
						<uform:field label="Third Event Date" name="EventDate2" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate2, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Third Date if event has multiple dates." />
						<uform:field label="Fourth Event Date" name="EventDate3" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate3, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Fourth Date if event has multiple dates." />
						<uform:field label="Fifth Event Date" name="EventDate4" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate4, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Fifth Date if event has multiple dates." />
					</cfif>
					<uform:field label="Registration Deadline" name="Registration_Deadline" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.Registration_Deadline, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Accept Registration up to this date" />
					<uform:field label="Registration Start Time" name="Registration_BeginTime" isDisabled="true" value="#TimeFormat(Session.UserSuppliedInfo.PickedEvent.Registration_BeginTime, 'hh:mm tt')#" type="text" pluginSetup="#timeConfig#" hint="The Beginning Time onSite Registration begins" />
					<uform:field label="Event Start Time" name="Event_StartTime" isDisabled="true" type="text" value="#TimeFormat(Session.UserSuppliedInfo.PickedEvent.Event_StartTime, 'hh:mm tt')#" pluginSetup="#timeConfig#" hint="The starting time of this event" />
					<uform:field label="Event End Time" name="Event_EndTime" isDisabled="true" type="text" value="#TimeFormat(Session.UserSuppliedInfo.PickedEvent.Event_EndTime, 'hh:mm tt')#" pluginSetup="#timeConfig#" hint="The ending time of this event" />
				</uForm:fieldset>
				<uForm:fieldset legend="Event Description">
					<uform:field label="Event Short Title" name="ShortTitle" isDisabled="true" value="#Session.UserSuppliedInfo.PickedEvent.ShortTitle#" maxFieldLength="50" type="text" hint="Short Event Title of Event" />
					<uform:field label="Event Description" name="LongDescription" isDisabled="true" value="#Session.UserSuppliedInfo.PickedEvent.LongDescription#" type="textarea" hint="Description of this meeting or event" />
				</uForm:fieldset>
				<uForm:fieldset legend="Message to Participants">
					<uform:field label="Additional Information" name="PostAdditionalMsg" isDisabled="false" type="textarea" hint="Any Additional Information for Posting" />
				</uForm:fieldset>
			</uForm:form>
			<cfelse>
				<cfif not isDefined("URL.PerformAction")>
					<cfswitch expression="#Session.UserSuppliedInfo.FBPost.PerformAction#">
						<cfcase value="FacebookAuthenticate">
							<cfscript>
								import plugins.EventRegistration.library.FacebookSDK.sdk.FacebookApp;
								import plugins.EventRegistration.library.FacebookSDK.sdk.FacebookGraphAPI;

								userID = 0;

								if (Session.UserSuppliedInfo.FB.AppID is "" or Session.UserSuppliedInfo.FB.AppSecretKey is "") {
								} else {
									// Create facebookApp instance
									facebookApp = new FacebookApp(appId=Session.UserSuppliedInfo.FB.AppID, secretKey=Session.UserSuppliedInfo.FB.AppSecretKey);

									userId = facebookApp.getUserId();

									if (userId) {
										try {
											userAccessToken = facebookApp.getUserAccessToken();
											facebookGraphAPI = new FacebookGraphAPI(accessToken=userAccessToken, appId=Session.UserSuppliedInfo.FB.AppID);
											pageAccessToken = FacebookGraphAPI.getPageAccessToken("172096152818693");
											facebookPageGraphAPI = new FacebookGraphAPI(accessToken=pageAccessToken, appId=Session.UserSuppliedInfo.FB.AppID);
											userObject = FacebookGraphAPI.getObject(id=userId);
											userFriends = FacebookGraphAPI.getConnections(id=userId, type='taggable_friends', limit=10);
											authenticated = true;
										} catch (any exception) {
											// Usually an invalid session (OAuthInvalidTokenException), for example if the user logged out from facebook.com
											userId = 0;
											facebookGraphAPI = new FacebookGraphAPI();
										}
									} else {
										facebookGraphAPI = new FacebookGraphAPI();
									}

									if (userId eq 0) {
										parameters = {scope=Session.UserSuppliedInfo.FB.AppScope};
										loginUrl = facebookApp.getLoginUrl(parameters);
									};
								}
							</cfscript>
							<div id="fb-root"></div>
							<script>
								window.fbAsyncInit = function() {
									FB.init({
										appId   : '#facebookApp.getAppId()#',
										cookie  : true, // enable cookies to allow the server to access the session
										oauth	  : true, // OAuth 2.0
										status  : false, // check login status
										xfbml   : true // parse XFBML
									});
									FB.Canvas.setSize({height:1800});
								};

								(function() {
									var e = document.createElement('script');
									e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
									e.async = true;
									document.getElementById('fb-root').appendChild(e);
								}());

								<cfif userId eq 0>
									function addLoginListener() {
										// whenever the user install the app or login, we refresh the page
										FB.Event.subscribe('auth.login', function(response) {
											window.location.reload();
										});
									}

									function login() {
										FB.login(function(response) {
											if (response.authResponse) {
												// user successfully authenticated in
												window.location.reload();
											} else {
												WriteDump(response.authResponse);
												// user cancelled login
											}
										}, {scope:'#Session.UserSuppliedInfo.FB.AppScope#'});
									}
								</cfif>
							</script>

							<cfif userId eq 0>
								<h2 align="center">Login To Facebook</h2>
								<div class="alert-box">Please click the Login To Facebook Link Below to allow this website the ability to publish this newly created event to the Organization's Facebook Page.<br>
								<br /><br /><a href="javascript:login()" class="art-button">Login To Facebook</a>
							    </div>
								<hr />
							<cfelse>
								<cfif FBMsg CONTAINS "172096152818693_">
									<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.default&UserAction=PostToFB&Successful=True" addtoken="false">
								<cfelseif isNumeric(FBMsg)>
									<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.default&UserAction=PostToFB&Successful=True" addtoken="false">
								<cfelse>
									<div class="alert-box error">An error has occurred in posting this event to the organization's Facebook Page.</div>
								</cfif>
							</cfif>
						</cfcase>
					</cfswitch>
				<cfelseif isDefined("URL.PerformAction")>
					<cfswitch expression="#URL.PerformAction#">
						<cfcase value="LoginFailed">
							<div class="alert-box error">Login to Facebook has failed as the wrong username and/or password was provided.</div>
						</cfcase>
						<cfcase value="PostMessageToFB">
							<cfset oFacebook = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/FacebookSDK/sdk/FacebookApp")>
							<cfparam name="oAuthState" default="0">
							<cfparam name="error" default="">
							<cfparam name="error_reason" default="">
							<cfparam name="error_description" default="">
							<cfparam name="code" default="">

							<cfif isDefined("URL.error") and LEN(url.error)>
								<cfset oAuthState = -1>
							</cfif>

							<cfif isDefined("url.code") and Len(url.code)>
								<cfset oAuthState = 1>
								<cfset stAuthToken = oFacebook.getUserAccessToken()>
								<cfdump var="#Variables.stAuthToken#">
								<cfabort>
								<cfset Session.UserSuppliedInfo.FB.UserStatus = StructNew()>
								<cfset Session.UserSuppliedInfo.FB.UserStatus.AccessToken = stAuthToken.access_token>
								<cfset Session.UserSuppliedInfo.FB.UserStatus.TokenExpires = stAuthToken.token_expires>
							</cfif>

							<cfif oAuthState EQ 0>
								<p>This is an example of a basic Facebook oAuth integration, using ColdFusion.<br />
								The example demonstrates authorising an application acquiring the authorisation code, and then grabbing the current Facebook users details.</p>
								<p>Generally the next step would be to persist the authorisation code against the users id so that you can interact with the Graph API on behalf of a user at a later date.</p>
								<a href="https://www.facebook.com/dialog/oauth?client_id=#Session.UserSuppliedInfo.FB.AppID#&amp;redirect_uri=#Session.UserSuppliedInfo.FB.RedirectURI#&amp;scope=#Session.UserSuppliedInfo.FB.AppScope#">Get started.</a>
							<cfelseif oAuthState EQ -1>
								<p>Whoops, looks like there has been an error! Details below.</p>
								<dl>
									<dt>error</dt>
									<dd>#url.error#</dd>
									<dt>error_reason</dt>
									<dd>#url.error_reason#</dd>
									<dt>error_description</dt>
									<dd>#url.error_description#</dd>
								</dl>
							<cfelseif oAuthState EQ 1>
								<dl>
									<dt>access_token</dt>
									<dd>#Session.UserSuppliedInfo.FB.UserStatus.AccessToken#<dd>

									<dt>token_expires</dt>
									<dd>#Session.UserSuppliedInfo.FB.UserStatus.TokenExpires#</dd>
								</dl>
								<p><a href="/graph.cfm">Now query the graph for the users details.</a></p>
							</cfif>
						</cfcase>
					</cfswitch>
				</cfif>
			</cfif>
		</div>
	</div>
	</cfoutput>
</cfif>

