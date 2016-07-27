<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>
<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
<cfoutput>
	<cfif not isDefined("URL.FormRetry") and not isDefined("URL.EventStatus")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Register Participant for: #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif Session.getSelectedEvent.WebinarAvailable EQ 0><cfinput type="hidden" name="WebinarParticipant" value="0"></cfif>
				<div class="panel-body">
					<div class="alert alert-info"><p>Complete this form to register users for the selected event</p></div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Description:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.LongDescription#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Registration Deadline:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.Registration_Deadline, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Registration Begin Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Registration_BeginTime, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Start Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Event_StartTime, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event End Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Event_EndTime, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Agenda:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventAgenda#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Target Audience:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventTargetAudience#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Strategies:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventStrategies#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Special Instructions:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventSpecialInstructions#</p></div>
					</div>
					<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Participant via Webinar:&nbsp;</label>
							<div class="col-sm-8"><cfselect name="WebinarParticipant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant use Webinar Option for Event</option></cfselect>
						</div>
					</cfif>
					<cfif Session.getSelectedEvent.LocationID GT 0 and Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Participant via Facility:&nbsp;</label>
							<div class="col-sm-8"><cfselect name="FacilityParticipant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant be at Facility for Event</option></cfselect>
						</div>
					</cfif>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Send Email Confirmations:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="EmailConfirmations" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Send Email Confirmations to Participants</option></cfselect>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">School District:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="DistrictName" class="form-control" Required="Yes" Multiple="No" query="Session.GetMembershipOrganizations" value="TContent_ID" Display="OrganizationName"  queryposition="below"><option value="----">Select School District Participant Is From</option><option value="0">Participant is from a Business</option></cfselect>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Register for Event"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Register Participant for: #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif Session.getSelectedEvent.WebinarAvailable EQ 0><cfinput type="hidden" name="WebinarParticipant" value="0"></cfif>
				<cfif isDefined("Session.FormErrors")>
					<div class="panel-body">
						<cfif ArrayLen(Session.FormErrors) GTE 1>
							<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
						</cfif>
					</div>
				</cfif>
				<div class="panel-body">
					<div class="alert alert-info"><p>Complete this form to register users for the selected event</p></div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Description:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.LongDescription#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Registration Deadline:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.Registration_Deadline, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Registration Begin Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Registration_BeginTime, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Start Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Event_StartTime, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event End Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Event_EndTime, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Agenda:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventAgenda#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Target Audience:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventTargetAudience#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Strategies:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventStrategies#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Special Instructions:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventSpecialInstructions#</p></div>
					</div>
					<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Participant via Webinar:&nbsp;</label>
							<div class="col-sm-8"><cfselect name="WebinarParticipant" class="form-control" selected="#Session.UserRegister.FirstStep.WebinarParticipant#" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant use Webinar Option for Event</option></cfselect>
						</div>
					</cfif>
					<cfif Session.getSelectedEvent.LocationID GT 0 and Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Participant via Facility:&nbsp;</label>
							<div class="col-sm-8"><cfselect name="FacilityParticipant" class="form-control" Required="Yes" selected="#Session.UserRegister.FirstStep.FacilityParticipant#" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant be at Facility for Event</option></cfselect>
						</div>
					</cfif>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Send Email Confirmations:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="EmailConfirmations" class="form-control" Required="Yes" Multiple="No" selected="#Session.UserRegister.FirstStep.EmailConfirmations#" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Send Email Confirmations to Participants</option></cfselect>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">School District:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="DistrictName" class="form-control" Required="Yes" selected="#Session.UserRegister.FirstStep.DistrictName#" Multiple="No" query="Session.GetMembershipOrganizations" value="TContent_ID" Display="OrganizationName"  queryposition="below"><option value="----">Select School District Participant Is From</option><option value="0">Participant is from a Business</option></cfselect>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Register for Event"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.EventID") and isDefined("URL.EventStatus")>
		<cfswitch expression="#URL.EventStatus#">
			<cfcase value="ShowCorporations">
				<div class="panel panel-default">
					<div class="panel-heading"><h1>Register Participant for: #Session.getSelectedEvent.ShortTitle#</h1></div>
					<cfform action="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=RegisterParticipants" method="post" id="AddEvent" class="form-horizontal">
						<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
						<cfinput type="hidden" name="formSubmit" value="true">
						<cfif isDefined("Session.FormErrors")>
							<cfif ArrayLen(Session.FormErrors) GTE 1>
								<div class="panel-body">
									<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
								</div>
							</cfif>
						</cfif>
						<div class="panel-body">
							<div class="alert alert-warning"><p>To register individuals for this event, simply check individuals from the provided list. <span class="text-danger"><strong>If you are registering someone not on the provided list, please add them in the space below and click the Add button before checking the boxes to register participants.</strong></span></p></div>
						</div>
						<div class="panel-body">
							<cfif Session.getSelectedEvent.MealProvided EQ 1>
								<div class="form-group">
									<label for="EventDate" class="control-label col-sm-3">Each Participant Staying for Meal?:&nbsp;</label>
									<div class="col-sm-8"><cfselect name="RegisterParticipantStayForMeal" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Everyone Staying for Meal Being Registered</option></cfselect>
								</div>
							<cfelse>
								<cfinput type="hidden" name="RegisterParticipantStayForMeal" value="0">
							</cfif>
							<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
								<div class="form-group">
									<label for="EventDate" class="control-label col-sm-3">Each Participant Utilizing Webinar Option?:&nbsp;</label>
									<div class="col-sm-8"><cfselect name="RegisterParticipantWebinarOption" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Everyone Participanting via Webinar</option></cfselect>
								</div>
							<cfelse>
								<cfinput type="hidden" name="RegisterParticipantWebinarOption" value="0">
							</cfif>
							<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
							<cfloop query="Session.GetSelectedAccountsWithinOrganization">
								<cfquery name="CheckUserAlreadyRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select User_ID, EventID
									From p_EventRegistration_UserRegistrations
									Where User_ID = <cfqueryparam value="#Session.GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar">
										and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfset CurrentModRow = #Session.GetSelectedAccountsWithinOrganization.CurrentRow# MOD 4>
								<cfswitch expression="#Variables.CurrentModRow#">
									<cfcase value="1">
										<tr><td width="25%" <cfif CheckUserAlreadyRegistered.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegistered.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#" disabled>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelseif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#" checked>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#" >&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</cfif></td>
									</cfcase>
									<cfcase value="0">
										<td width="25%" <cfif CheckUserAlreadyRegistered.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegistered.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#" disabled>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelseif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#" checked>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#" >&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</cfif></td></tr>
									</cfcase>
									<cfdefaultcase>
										<td width="25%" <cfif CheckUserAlreadyRegistered.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegistered.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#" disabled>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelseif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#" checked>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#" >&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</cfif></td>
									</cfdefaultcase>
								</cfswitch>
							</cfloop>
							<cfswitch expression="#Variables.CurrentModRow#">
								<cfcase value="0"></cfcase>
								<cfcase value="1"><td colspan="3">&nbsp;</td></tr></cfcase>
								<cfdefaultcase><td>&nbsp;</td></tr></cfdefaultcase>
							</cfswitch>
							</table>
							<hr>
							<table id="NewParticipantRows" class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
								<thead>
									<tr>
										<td>Row</td>
										<td class="col-sm-3">Participant First Name</td>
										<td class="col-sm-4">Participant Last Name</td>
										<td class="col-sm-3">Participant Email</td>
										<td class="col-sm-3">Actions</td>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>1</td>
										<td><cfinput type="text" class="form-control" id="ParticipantFirstName" name="ParticipantFirstName" required="no"></td>
										<td><cfinput type="text" class="form-control" id="ParticipantLastName" name="ParticipantLastName" required="no"></td>
										<td><cfinput type="text" class="form-control" id="ParticipantEmail" name="ParticipantEmail" required="no"></td>
										<td><input type="button" id="addParticipantRow" class="btn btn-primary btn-sm" value="Add" onclick="AddRow()"></td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="panel-footer">
							<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
							<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Register Participants"><br /><br />
						</div>
						<script>
							var table = document.getElementById('NewParticipantRows'),
								tbody = table.getElementsByTagName('tbody')[0],
								clone = tbody.rows[0].cloneNode(true);

							function AddRow() {
								structvar = {
									Datasource: "#rc.$.globalConfig('datasource')#",
									DBUsername: "#rc.$.globalConfig('dbusername')#",
									DBPassword: "#rc.$.globalConfig('dbpassword')#",
									PackageName: "#rc.pc.getPackage()#",
									CGIScriptName: "#CGI.Script_name#",
									CGIPathInfo: "#CGI.path_info#",
									SiteID: "#rc.$.siteConfig('siteID')#",
									EventID: "#URL.EventID#"
								};



								$.ajax({
									url: '/plugins/#rc.pc.getPackage()#/library/components/EventServices.cfc',
									type: "POST",
									dataType: 'json',
									data: {method: "AddParticipantToDatabase",
										returnFormat: "json",
										jsStruct: JSON.stringify({"DBInfo": structvar, "Email": document.getElementById("ParticipantEmail").value, "Fname": document.getElementById("ParticipantFirstName").value, "Lname": document.getElementById("ParticipantLastName").value })
									},
									success: function (msg) {
										window.location.reload(true);
									}
								});
							}
						</script>
					</cfform>
				</div>
			</cfcase>
			<cfcase value="PickedParticipants">

			</cfcase>
			<cfcase value="AddNewParticipants">
				<cfif not isDefined("URL.FormRetry")>
					<div class="panel panel-default">
						<div class="panel-heading"><h1>Register Participant for: #Session.getSelectedEvent.ShortTitle#</h1></div>
						<cfform action="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=AddNewParticipants" method="post" id="AddEvent" class="form-horizontal">
							<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
							<cfinput type="hidden" name="formSubmit" value="true">
							<div class="panel-body">
								<div class="alert alert-info"><p>Enter Participants Information for any individual that was not on the previous screen who you would like to have attend this event.</p></div>
								<div class="panel-heading"><h1>First New Participant</h1></div>
								<div class="form-group">
									<label for="Participant1FirstName" class="control-label col-sm-3">Participant's First Name:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant1FirstName" name="Participant1FirstName" required="no"></div>
								</div>
								<div class="form-group">
									<label for="Participant1LastName" class="control-label col-sm-3">Participant's Last Name:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant1LastName" name="Participant1LastName" required="no"></div>
								</div>
								<div class="form-group">
									<label for="Participant1EmailAddress" class="control-label col-sm-3">Participant's Email Address:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant1EmailAddress" name="Participant1EmailAddress" required="no"></div>
								</div>
								<cfif Session.getSelectedEvent.MealProvided EQ 1>
									<div class="form-group">
										<label for="Participant1WantsMeal" class="control-label col-sm-3">Participant Staying for Meal:&nbsp;</label>
										<div class="col-sm-8"><cfselect name="Participant1WantsMeal" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant Stay for Meal</option></cfselect>
									</div>
								</cfif>
								<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
									<div class="form-group">
										<label for="Participant1WantsWebinar" class="control-label col-sm-3">Participant Attending via Webinar:&nbsp;</label>
										<div class="col-sm-8"><cfselect name="Participant1WantsWebinar" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant attend via Webinar</option></cfselect>
									</div>
								</cfif>
								<div class="panel-heading"><h1>Second New Participant</h1></div>
								<div class="form-group">
									<label for="Participant2FirstName" class="control-label col-sm-3">Participant's First Name:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant2FirstName" name="Participant2FirstName" required="no"></div>
								</div>
								<div class="form-group">
									<label for="Participant2LastName" class="control-label col-sm-3">Participant's Last Name:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant2LastName" name="Participant2LastName" required="no"></div>
								</div>
								<div class="form-group">
									<label for="Participant2EmailAddress" class="control-label col-sm-3">Participant's Email Address:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant2EmailAddress" name="Participant2EmailAddress" required="no"></div>
								</div>
								<cfif Session.getSelectedEvent.MealProvided EQ 1>
									<div class="form-group">
										<label for="Participant2WantsMeal" class="control-label col-sm-3">Participant Staying for Meal:&nbsp;</label>
										<div class="col-sm-8"><cfselect name="Participant2WantsMeal" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant Stay for Meal</option></cfselect>
									</div>
								</cfif>
								<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
									<div class="form-group">
										<label for="Participant2WantsWebinar" class="control-label col-sm-3">Participant Attending via Webinar:&nbsp;</label>
										<div class="col-sm-8"><cfselect name="Participant2WantsWebinar" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant attend via Webinar</option></cfselect>
									</div>
								</cfif>
								<div class="panel-heading"><h1>Third New Participant</h1></div>
								<div class="form-group">
									<label for="Participant3FirstName" class="control-label col-sm-3">Participant's First Name:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant3FirstName" name="Participant3FirstName" required="no"></div>
								</div>
								<div class="form-group">
									<label for="Participant3LastName" class="control-label col-sm-3">Participant's Last Name:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant3LastName" name="Participant3LastName" required="no"></div>
								</div>
								<div class="form-group">
									<label for="Participant3EmailAddress" class="control-label col-sm-3">Participant's Email Address:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant3EmailAddress" name="Participant3EmailAddress" required="no"></div>
								</div>
								<cfif Session.getSelectedEvent.MealProvided EQ 1>
									<div class="form-group">
										<label for="Participant3WantsMeal" class="control-label col-sm-3">Participant Staying for Meal:&nbsp;</label>
										<div class="col-sm-8"><cfselect name="Participant3WantsMeal" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant Stay for Meal</option></cfselect>
									</div>
								</cfif>
								<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
									<div class="form-group">
										<label for="Participant3WantsWebinar" class="control-label col-sm-3">Participant Attending via Webinar:&nbsp;</label>
										<div class="col-sm-8"><cfselect name="Participant3WantsWebinar" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant attend via Webinar</option></cfselect>
									</div>
								</cfif>
								<div class="panel-heading"><h1>Fourth New Participant</h1></div>
								<div class="form-group">
									<label for="Participant4FirstName" class="control-label col-sm-3">Participant's First Name:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant4FirstName" name="Participant4FirstName" required="no"></div>
								</div>
								<div class="form-group">
									<label for="Participant4LastName" class="control-label col-sm-3">Participant's Last Name:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant4LastName" name="Participant4LastName" required="no"></div>
								</div>
								<div class="form-group">
									<label for="Participant4EmailAddress" class="control-label col-sm-3">Participant's Email Address:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant4EmailAddress" name="Participant4EmailAddress" required="no"></div>
								</div>
								<cfif Session.getSelectedEvent.MealProvided EQ 1>
									<div class="form-group">
										<label for="Participant4WantsMeal" class="control-label col-sm-3">Participant Staying for Meal:&nbsp;</label>
										<div class="col-sm-8"><cfselect name="Participant4WantsMeal" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant Stay for Meal</option></cfselect>
									</div>
								</cfif>
								<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
									<div class="form-group">
										<label for="Participant4WantsWebinar" class="control-label col-sm-3">Participant Attending via Webinar:&nbsp;</label>
										<div class="col-sm-8"><cfselect name="Participant4WantsWebinar" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant attend via Webinar</option></cfselect>
									</div>
								</cfif>
								<div class="panel-heading"><h1>Fifth New Participant</h1></div>
								<div class="form-group">
									<label for="Participant5FirstName" class="control-label col-sm-3">Participant's First Name:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant5FirstName" name="Participant5FirstName" required="no"></div>
								</div>
								<div class="form-group">
									<label for="Participant5LastName" class="control-label col-sm-3">Participant's Last Name:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant5LastName" name="Participant5LastName" required="no"></div>
								</div>
								<div class="form-group">
									<label for="Participant5EmailAddress" class="control-label col-sm-3">Participant's Email Address:&nbsp;</label>
									<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participant5EmailAddress" name="Participant5EmailAddress" required="no"></div>
								</div>
								<cfif Session.getSelectedEvent.MealProvided EQ 1>
									<div class="form-group">
										<label for="Participant5WantsMeal" class="control-label col-sm-3">Participant Staying for Meal:&nbsp;</label>
										<div class="col-sm-8"><cfselect name="Participant5WantsMeal" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant Stay for Meal</option></cfselect>
									</div>
								</cfif>
								<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
									<div class="form-group">
										<label for="Participant5WantsWebinar" class="control-label col-sm-3">Participant Attending via Webinar:&nbsp;</label>
										<div class="col-sm-8"><cfselect name="Participant5WantsWebinar" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant attend via Webinar</option></cfselect>
									</div>
								</cfif>
							</div>
							<div class="panel-footer">
								<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
								<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Register Participants"><br /><br />
							</div>
						</cfform>
					</div>
					<cfdump var="#Session.GetSelectedAccountsWithinOrganization#">
				<cfelseif isDefined("FORM.FormRetry")>
					<cfdump var="#Session.UserRegister#">
				</cfif>
			</cfcase>
		</cfswitch>

	</cfif>
</cfoutput>

<!---
<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">

<cfoutput>
	<cfif not isDefined("URL.EventStatus") and not isDefined("URL.Records")>
		<cflock timeout="60" scope="SESSION" type="Exclusive">
			<cfset Session.FormData = #StructNew()#>
			<cfset Session.FormErrors = #ArrayNew()#>
		</cflock>
		<cfquery name="GetMembershipOrganizations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Active
			From eMembership
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			Order by OrganizationName
		</cfquery>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Registering Participant for Workshop/Event: #Session.UserSuppliedInfo.PickedEvent.ShortTitle#</h3>
			</div>
			<div class="art-blockcontent">
				<div class="alert-box notice">Please complete this form to register user(s) to this event.</div>
				<hr>
				<uForm:form action="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=CorporationSelected" method="Post" id="RegisterParticipants" errors="#Session.FormErrors#" errorMessagePlacement="both"
					commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
					cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events&compactDisplay=false"
					submitValue="Register Participants" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
					<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
					<input type="hidden" name="formSubmit" value="true">
					<input type="hidden" name="PerformAction" value="ListParticipantsInOrganization">
					<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 0>
						<input type="hidden" name="WebinarParticipant" value="0">
					</cfif>
					<uForm:fieldset legend="Event Date and Time">
						<uform:field label="Primary Event Date" name="EventDate" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, First Date if event has multiple dates." />
						<cfif Session.UserSuppliedInfo.PickedEvent.EventSpanDates EQ 1>
							<uform:field label="Second Event Date" name="EventDate1" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate1, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Second Date if event has multiple dates." />
							<cfif isDefined("Session.UserSuppliedInfo.PickedEvent.EventDate2")><uform:field label="Third Event Date" name="EventDate2" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate2, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Third Date if event has multiple dates." /></cfif>
							<cfif isDefined("Session.UserSuppliedInfo.PickedEvent.EventDate3")><uform:field label="Fourth Event Date" name="EventDate3" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate3, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Fourth Date if event has multiple dates." /></cfif>
							<cfif isDefined("Session.UserSuppliedInfo.PickedEvent.EventDate4")><uform:field label="Fifth Event Date" name="EventDate4" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate4, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Fifth Date if event has multiple dates." /></cfif>
							<cfif isDefined("Session.UserSuppliedInfo.PickedEvent.EventDate5")><uform:field label="Sixth Event Date" name="EventDate5" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate5, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Sixth Date if event has multiple dates." /></cfif>
						</cfif>
						<uform:field label="Registration Deadline" name="Registration_Deadline" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.Registration_Deadline, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Accept Registration up to this date" />
						<uform:field label="Registration Start Time" name="Registration_BeginTime" isDisabled="true" value="#TimeFormat(Session.UserSuppliedInfo.PickedEvent.Registration_BeginTime, 'hh:mm tt')#" type="text" hint="The Beginning Time onSite Registration begins" />
						<uform:field label="Event Start Time" name="Event_StartTime" isDisabled="true" type="text" value="#TimeFormat(Session.UserSuppliedInfo.PickedEvent.Event_StartTime, 'hh:mm tt')#" hint="The starting time of this event" />
						<uform:field label="Event End Time" name="Event_EndTime" isDisabled="true" type="text" value="#TimeFormat(Session.UserSuppliedInfo.PickedEvent.Event_EndTime, 'hh:mm tt')#" hint="The ending time of this event" />
					</uForm:fieldset>
					<uForm:fieldset legend="Event Description">
						<uform:field label="Event Short Title" name="ShortTitle" isDisabled="true" value="#Session.UserSuppliedInfo.PickedEvent.ShortTitle#" maxFieldLength="50" type="text" hint="Short Event Title of Event" />
						<uform:field label="Event Description" name="LongDescription" isDisabled="true" value="#Session.UserSuppliedInfo.PickedEvent.LongDescription#" type="textarea" hint="Description of this meeting or event" />
					</uForm:fieldset>
					<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
						<uForm:fieldset legend="Webinar Available">
							<uform:field label="Participating via Webinar" name="WebinarParticipant" type="select" isRequired="true" hint="Will everyone you register be participating via Webinar?">
								<uform:option display="No" value="0" isSelected="true" />
								<uform:option display="Yes" value="1" isSelected="false" />
							</uform:field>
						</uForm:fieldset>
					</cfif>
					<cfif Session.UserSuppliedInfo.PickedEvent.LocationID GT 0 and Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
						<uForm:fieldset legend="Participate at Facility">
							<uform:field label="Participating at Facility" name="FacilityParticipant" type="select" isRequired="true" hint="Will everyone you register be participating at the Facility Location?">
								<uform:option display="No" value="0" isSelected="true" />
								<uform:option display="Yes" value="1" isSelected="false" />
							</uform:field>
						</uForm:fieldset>
					</cfif>
					<uForm:fieldset legend="Email Confirmation">
						<uform:field label="Send Email Confirmations" name="EmailConfirmations" type="select" isRequired="true" hint="Do you want to send an email confirmation to participants about registering for this event?">
							<uform:option display="No" value="0" isSelected="true" />
								<uform:option display="Yes" value="1" isSelected="false" />
							</uform:field>
					</uForm:fieldset>
					<uForm:fieldset legend="School District">
						<uform:field label="District Name" name="DistrictName" type="select" isRequired="true" hint="Which School District does user work at?">
							<uform:option display="Business Organization" value="0" isSelected="true" />
							<cfloop query="GetMembershipOrganizations">
								<uform:option display="#GetMembershipOrganizations.OrganizationName#" value="#GetMembershipOrganizations.OrganizationDomainName#" isSelected="false" />
							</cfloop>
						</uform:field>
					</uForm:fieldset>
				</uForm:form>
			</div>
		</div>
	<cfelseif isDefined("URL.EventID") and isDefined("URL.EventStatus")>
		<cfswitch expression="#URL.EventStatus#">
					<cfcase value="CorporationSelected">
						<cfif Session.UserSuppliedInfo.EventRegistration.NumberOfUserAccountsWithinOrganization EQ 0>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=RegisterParticipantsToEvent" addtoken="true">
						<cfelse>
							<div class="art-block clearfix">
								<div class="art-blockheader">
									<h3 class="t">Registering Participant for Workshop/Event: #Session.UserSuppliedInfo.PickedEvent.ShortTitle#</h3>
								</div>
								<div class="art-blockcontent">
									<div class="alert-box notice">Please select the User(s) you would like to register for this event. If you would like to register individuals not listed on this screen you will have the opportunity to enter their information on the next screen.</div>
									<hr>
									<Form Method="Post" Action="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=RegisterParticipantsToEvent" id="RegisterParticipants">
										<input type="Hidden" Name="formSubmit" Value="Submit">
										<input type="Hidden" Name="PerformAction" Value="RegisterParticipantsToEventWithAccounts">
										<Table Border="0" CellSpacing="0" CellPadding="0" Width="100%">
											<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
												<tr>
													<td colspan="2">Is each Participant Staying for Meal that you are registering for from this list?</td>
													<td><select name="RegisterParticipantStayForMeal"><option value="1" selected>Yes</option><option value="0">No</option></select></td>
												</tr>
											</cfif>
											<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
												<tr>
													<td colspan="2">Is each Participant Utilizing Webinar Option that you are registering for from this list?</td>
													<td><select name="RegisterParticipantWebinarOption"><option value="1" selected>Yes</option><option value="0">No</option></select></td>
												</tr>
											</cfif>
											<cfloop query="Session.UserSuppliedInfo.EventRegistration.SelectedOrganization">
												<cfquery name="CheckUserAlreadyRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
													Select User_ID, EventID
													From eRegistrations
													Where User_ID = <cfqueryparam value="#Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.UserID#" cfsqltype="cf_sql_varchar">
														and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
												</cfquery>
												<cfset CurrentModRow = #Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.CurrentRow# MOD 3>
												<cfswitch expression="#Variables.CurrentModRow#">
													<cfcase value="1">
														<tr><td width="33%" <cfif CheckUserAlreadyRegistered.RecordCount>Style="Color: ##009900;"</cfif>><cfoutput><input type="CheckBox" Name="ParticipantEmployee" Value="#Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.UserID#" <cfif CheckUserAlreadyRegistered.RecordCount>disabled <cfelseif Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.UserID EQ Session.Mura.UserID> Checked="Yes"</cfif>>&nbsp;&nbsp;#Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.LName#, #Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.FName#</cfoutput></td>
													</cfcase>
													<cfcase value="0">
														<td width="33%" <cfif CheckUserAlreadyRegistered.RecordCount>Style="Color: ##009900;"</cfif>><cfoutput><input type="CheckBox" Name="ParticipantEmployee" Value="#Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.UserID#" <cfif CheckUserAlreadyRegistered.RecordCount>disabled <cfelseif Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.UserID EQ Session.Mura.UserID> Checked="Yes"</cfif>>&nbsp;&nbsp;#Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.LName#, #Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.FName#</cfoutput></td></tr>
													</cfcase>
													<cfdefaultcase>
														<td Width="34%" <cfif CheckUserAlreadyRegistered.RecordCount>Style="Color: ##009900;"</cfif>><cfoutput><input type="CheckBox" Name="ParticipantEmployee" Value="#Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.UserID#" <cfif CheckUserAlreadyRegistered.RecordCount>disabled <cfelseif Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.UserID EQ Session.Mura.UserID> Checked="Yes"</cfif>>&nbsp;&nbsp;#Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.LName#, #Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.FName#</cfoutput></td>
													</cfdefaultcase>
												</cfswitch>
											</cfloop>
											<cfswitch expression="#Variables.CurrentModRow#">
												<cfcase value="0"></cfcase>
												<cfcase value="1"><td colspan="2">&nbsp;</td></tr></cfcase>
												<cfdefaultcase><td>&nbsp;</td></tr></cfdefaultcase>
											</cfswitch>
											<tr>
												<td colspan="3"><input type="Submit" class="primaryAction" Value="Register Participants For Event"></td>
											</tr>
										</Table>
									</Form>
								</div>
							</div>
						</cfif>
					</cfcase>
					<cfcase value="RegisterParticipantsToEvent">
						<div class="art-block clearfix">
							<div class="art-blockheader">
								<h3 class="t">Registering Participant for Workshop/Event: #Session.UserSuppliedInfo.PickedEvent.ShortTitle#</h3>
							</div>
							<div class="art-blockcontent">
								<cfif not StructKeyExists(Session.UserSuppliedInfo, "Registration")>
									<div class="alert-box notice">Please enter the Participant's Information that will be attending this event.</div>
								<cfelse>
									<div class="alert-box notice">Please enter the Participant's if any that were not listed on the previous page that will be attending this event with you.</div>
								</cfif>
								<hr>
								<uForm:form action="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=RegisterParticipantsToEvent" method="Post" id="RegisterParticipants" errors="#Session.FormErrors#" errorMessagePlacement="both"
									commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
									cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events&compactDisplay=false"
									submitValue="Register Participants to Event" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
									<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
									<input type="hidden" name="formSubmit" value="true">
									<input type="hidden" name="PerformAction" value="RegisterParticipantsToEvent">
									<input type="hidden" Name="MealProvided" Value="#Session.UserSuppliedInfo.PickedEvent.MealProvided#">
									<input type="hidden" Name="MealCost" Value="#Session.UserSuppliedInfo.PickedEvent.MealCost_Estimated#">
									<uForm:fieldset legend="First Participant's Information">
										<uform:field label="First Name" name="Participant1FirstName" maxFieldLength="50" type="text" hint="First Name of Particiapnt" />
										<uform:field label="Last Name" name="Participant1LastName" maxFieldLength="50" type="text" hint="Last Name of Particiapnt" />
										<uform:field label="Email Address" name="Participant1EmailAddress" maxFieldLength="50" type="text" hint="Email Address of Particiapnt" />
										<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
											<uform:field label="Staying for Meal" name="Participant1WantsMeal" type="select" hint="Will you be staying for the Meal?">
												<uform:option display="Yes" value="1" isSelected="true" />
												<uform:option display="No" value="0" />
											</uform:field>
										</cfif>
										<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
											<uform:field label="Participate via Webinar" name="Participant1WantsWebinar" type="select" hint="Will you be participating via Webinar?">
												<uform:option display="Yes" value="1"  />
												<uform:option display="No" value="0"isSelected="true" />
											</uform:field>
										</cfif>
									</uForm:fieldset>
									<uForm:fieldset legend="Second Participant's Information">
										<uform:field label="First Name" name="Participant2FirstName" maxFieldLength="50" type="text" hint="First Name of Particiapnt" />
										<uform:field label="Last Name" name="Participant2LastName" maxFieldLength="50" type="text" hint="Last Name of Particiapnt" />
										<uform:field label="Email Address" name="Participant2EmailAddress" maxFieldLength="50" type="text" hint="Email Address of Particiapnt" />
										<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
											<uform:field label="Staying for Meal" name="Participant2WantsMeal" type="select" hint="Will you be staying for the Meal?">
												<uform:option display="Yes" value="1" isSelected="true" />
												<uform:option display="No" value="0" />
											</uform:field>
										</cfif>
										<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
											<uform:field label="Participate via Webinar" name="Participant2WantsWebinar" type="select" hint="Will you be participating via Webinar?">
												<uform:option display="Yes" value="1"  />
												<uform:option display="No" value="0"isSelected="true" />
											</uform:field>
										</cfif>
									</uForm:fieldset>
									<uForm:fieldset legend="Third Participant's Information">
										<uform:field label="First Name" name="Participant3FirstName" maxFieldLength="50" type="text" hint="First Name of Particiapnt" />
										<uform:field label="Last Name" name="Participant3LastName" maxFieldLength="50" type="text" hint="Last Name of Particiapnt" />
										<uform:field label="Email Address" name="Participant3EmailAddress" maxFieldLength="50" type="text" hint="Email Address of Particiapnt" />
										<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
											<uform:field label="Staying for Meal" name="Participant3WantsMeal" type="select" hint="Will you be staying for the Meal?">
												<uform:option display="Yes" value="1" isSelected="true" />
												<uform:option display="No" value="0" />
											</uform:field>
										</cfif>
										<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
											<uform:field label="Participate via Webinar" name="Participant3WantsWebinar" type="select" hint="Will you be participating via Webinar?">
												<uform:option display="Yes" value="1"  />
												<uform:option display="No" value="0"isSelected="true" />
											</uform:field>
										</cfif>
									</uForm:fieldset>
									<uForm:fieldset legend="Fourth Participant's Information">
										<uform:field label="First Name" name="Participant4FirstName" maxFieldLength="50" type="text" hint="First Name of Particiapnt" />
										<uform:field label="Last Name" name="Participant4LastName" maxFieldLength="50" type="text" hint="Last Name of Particiapnt" />
										<uform:field label="Email Address" name="Participant4EmailAddress" maxFieldLength="50" type="text" hint="Email Address of Particiapnt" />
										<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
											<uform:field label="Staying for Meal" name="Participant4WantsMeal" type="select" hint="Will you be staying for the Meal?">
												<uform:option display="Yes" value="1" isSelected="true" />
												<uform:option display="No" value="0" />
											</uform:field>
										</cfif>
										<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
											<uform:field label="Participate via Webinar" name="Participant4WantsWebinar" type="select" hint="Will you be participating via Webinar?">
												<uform:option display="Yes" value="1"  />
												<uform:option display="No" value="0"isSelected="true" />
											</uform:field>
										</cfif>
									</uForm:fieldset>
									<uForm:fieldset legend="Fifth Participant's Information">
										<uform:field label="First Name" name="Participant5FirstName" maxFieldLength="50" type="text" hint="First Name of Particiapnt" />
										<uform:field label="Last Name" name="Participant5LastName" maxFieldLength="50" type="text" hint="Last Name of Particiapnt" />
										<uform:field label="Email Address" name="Participant5EmailAddress" maxFieldLength="50" type="text" hint="Email Address of Particiapnt" />
										<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
											<uform:field label="Staying for Meal" name="Participant5WantsMeal" type="select" hint="Will you be staying for the Meal?">
												<uform:option display="Yes" value="1" isSelected="true" />
												<uform:option display="No" value="0" />
											</uform:field>
										</cfif>
										<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
											<uform:field label="Participate via Webinar" name="Participant5WantsWebinar" type="select" hint="Will you be participating via Webinar?">
												<uform:option display="Yes" value="1"  />
												<uform:option display="No" value="0"isSelected="true" />
											</uform:field>
										</cfif>
									</uForm:fieldset>
									<uForm:fieldset legend="Sixth Participant's Information">
										<uform:field label="First Name" name="Participant6FirstName" maxFieldLength="50" type="text" hint="First Name of Particiapnt" />
										<uform:field label="Last Name" name="Participant6LastName" maxFieldLength="50" type="text" hint="Last Name of Particiapnt" />
										<uform:field label="Email Address" name="Participant6EmailAddress" maxFieldLength="50" type="text" hint="Email Address of Particiapnt" />
										<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
											<uform:field label="Staying for Meal" name="Participant6WantsMeal" type="select" hint="Will you be staying for the Meal?">
												<uform:option display="Yes" value="1" isSelected="true" />
												<uform:option display="No" value="0" />
											</uform:field>
										</cfif>
										<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
											<uform:field label="Participate via Webinar" name="Participant6WantsWebinar" type="select" hint="Will you be participating via Webinar?">
												<uform:option display="Yes" value="1"  />
												<uform:option display="No" value="0"isSelected="true" />
											</uform:field>
										</cfif>
									</uForm:fieldset>
								</uForm:form>
							</div>
						</div>
					</cfcase>
				</cfswitch>
			</cfif>
</cfoutput>
--->