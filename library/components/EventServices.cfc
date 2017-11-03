<cfcomponent displayName="Event Registration Routines">

	<cffunction name="QRCodeImage" ReturnType="String" output="False">
		<cfargument name="Data" type="string" Required="True">
		<cfargument name="PluginDirectory" type="string" Required="True">
		<cfargument name="QRCodeImageFilename" type="string" Required="True">

		<cfset qr = createObject("component","plugins/#Arguments.PluginDirectory#/library/components/QRCode")>
		<cfset CurLoc = #ExpandPath("/")#>
		<cfset FileStoreLoc = #Variables.CurLoc# & "plugins/" & #Arguments.PluginDirectory# & "/library/images/QRCodes">
		<cfset ImageFilename = #Arguments.QRCodeImageFilename# & ".png">
		<cfset FileWritePathWithName = #Variables.FileStoreLoc# & "/" & #Variables.ImageFilename#>
		<cfset URLFileLocation = "/plugins/" & #Arguments.PluginDirectory# & "/library/images/QRCodes/" & #Variables.ImageFilename#>
		<cffile action="write" file="#Variables.FileWritePathWithName#" output="#qr.getQRCode("#Arguments.Data#",100,100,"png")#">
		<cfreturn #Variables.URLFileLocation#>
	</cffunction>

	<cffunction name="BarcodeImage" ReturnType="String" output="False">
		<cfargument name="Data" type="string" Required="True">
		<cfargument name="PluginDirectory" type="string" Required="True">
		<cfargument name="BarcodeImageFilename" type="string" Required="True">

		<cfset RegistrationIDBarcode = createObject("component","plugins/#Arguments.PluginDirectory#/library/components/BarbecueService")>
		<cfset CurLoc = #ExpandPath("/")#>
		<cfset FileStoreLoc = #Variables.CurLoc# & "plugins/" & #Arguments.PluginDirectory# & "/library/images/BarCodeTemp">
		<cfset ImageFilename = #Arguments.BarcodeImageFilename# & ".jpg">
		<cfset FileWritePathWithName = #Variables.FileStoreLoc# & "/" & #Variables.ImageFilename#>
		<cfset URLFileLocation = "/plugins/" & #Arguments.PluginDirectory# & "/library/images/BarCodeTemp/" & #Variables.ImageFilename#>
		<cffile action="write" file="#Variables.FileWritePathWithName#" output="#RegistrationIDBarcode.barcodeToBrowser(Arguments.Data)#">
		<cfreturn #Variables.URLFileLocation#>
	</cffunction>

	<cffunction name="GetLatitudeLongitudeProximity" ReturnType="Numeric" output="False">
		<cfargument name="FromLatitude" type="numeric" required="true" hint="I am the starting Latitude Value">
		<cfargument name="FromLongitude" type="numeric" required="true" hint="I am the starting Longitude Value">
		<cfargument name="ToLatitude" type="numeric" required="true" hint="I am the ending Latitude Value">
		<cfargument name="ToLongitude" type="numeric" required="true" hint="I am the ending Longitude Value">

		<cfset var LOCAL = {}>
		<cfset LOCAL.MilesPerLatitude = 69.09>
		<cfset LOCAL.DegreeDistance = RadiansToDegrees(
			ACos(
				Sin(DegreesToRadians(Arguments.FromLatitude)) * Sin(DegreesToRadians(Arguments.ToLatitude))
			)
			+
			(
				COS(DegreesToRadians(Arguments.FromLatitude)) * Cos(DegreesToRadians(Arguments.ToLatitude)) * COS(DegreesToRadians(Arguments.ToLongitude - Arguments.FromLognitude))
			)
		) />
		cfreturn Round(Local.DegreeDistance * LOCAL.MilesPerLatitude) />
	</cffunction>

	<cffunction name="DegreesToRadians" returntype="numeric" output="false" hint="I convert degrees to radians.">
		<cfargument name="Degrees" type="numeric" required="true" hint="I am the degree value to be converted to radians.">
		<cfreturn (Arguments.Degrees * PI() / 180) />
	</cffunction>

	<cffunction name="RadiansToDegrees" returntype="numeric" output="false" hint="I convert radians to degrees">
		<cfargument name="Radians" type="numeric" required="true" hint="I am the radian value to be converted to degrees.">
		<cfreturn (Arguments.Radians * 180 / PI()) />
	</cffunction>

	<cffunction name="ConvertCurrencyToDecimal" returntype="numeric" output="false" hint="I convert currency values to decimal for database">
		<cfargument name="Amount" type="string" required="true" hint="I am the currency amount to convert.">

		<cfset temp = #Replace(Arguments.Amount, '$', '', 'all')#>
		<cfset temp = #Replace(variables.temp, ',', '', 'all')#>
		<cfset newnumber = #NumberFormat(Variables.temp, '99999999.9999')#>
		<cfreturn variables.newnumber>
	</cffunction>

	<cffunction name="iCalUS" returntype="String" output="false" hint="Create iCal Event for Registered Users">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="RegistrationRecordID" required="true" type="numeric">

		<cfquery name="getRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select RegistrationID, RegistrationDate, User_ID, EventID, RequestsMeal, IVCParticipant, AttendeePrice, RegisterByUserID, OnWaitingList, Comments, WebinarParticipant
			From p_EventRegistration_UserRegistrations
			Where TContent_ID = <cfqueryparam value="#Arguments.RegistrationRecordID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery name="getEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, PGPPoints, MealAvailable, MealIncluded, AllowVideoConference, VideoConferenceInfo, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, LocationID, LocationRoomID, Facilitator, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
			From p_EventRegistration_Events
			Where TContent_ID = <cfqueryparam value="#getRegistration.EventID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery name="getEventLocation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, GeoCode_Latitude, GeoCode_Longitude
			From p_EventRegistration_Facility
			Where TContent_ID = <cfqueryparam value="#getEvent.LocationID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery name="getRegisteredUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#getRegistration.User_ID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfquery name="getEventFacilitator" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#getEvent.Facilitator#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset CRLF = #chr(13)# & #chr(10)#>
		<cfset CurrentDateTime = #Now()#>
		<cfset stEvent = StructNew()>
		<cfset stEvent.FacilitatorName = #getEventFacilitator.Fname# & " " & #getEventFacilitator.Lname#>
		<cfset stEvent.FacilitatorEmail = #getEventFacilitator.Email#>
		<cfset stEvent.EventLocation = #getEventLocation.FacilityName# & " (" & #getEventLocation.PhysicalAddress# & " " & #getEventLocation.PhysicalCity# & ", " & #getEventLocation.PhysicalState# & " " & #getEventLocation.PhysicalZipCode# & ")">
		<cfset stEvent.EventDescription = #getEvent.LongDescription# & "\n\n" & "Special Instructions:\n" & #getEvent.EventSpecialInstructions#>
		<cfset stEvent.Priority = 1>

		<cfset vCal = "BEGIN:VCALENDAR" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "PRODID: -//Northern Indiana ESC//Event Registration System//EN" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "VERSION:2.0" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "METHOD:REQUEST" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "BEGIN:VTIMEZONE" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TZID:Eastern Time" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "BEGIN:STANDARD" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "DTSTART:20061101T020000" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=1SU;BYMONTH=11" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TZOFFSETFROM:-0400" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TZOFFSETTO:-0500" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TZNAME:Standard Time" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "END:STANDARD" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "BEGIN:DAYLIGHT" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "DTSTART:20060301T020000" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=2SU;BYMONTH=3" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TZOFFSETFROM:-0500" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TZOFFSETTO:-0400" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TZNAME:Daylight Savings Time" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "END:DAYLIGHT" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "END:VTIMEZONE" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "BEGIN:VEVENT" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "UID:" & #getRegistration.RegistrationID# & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "ORGANIZER;CN=:" & #stEvent.FacilitatorName# & ":MAILTO:" & #stEvent.FacilitatorEmail# & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "DTSTAMP:" & #DateFormat(Now(), "yyyymmdd")# & "T" & TimeFormat(Now(), "HHmmss") & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "DTSTART;TZID=Eastern Time:" & #DateFormat(getEvent.EventDate, "yyyymmdd")# & "T" & TimeFormat(getEvent.Event_StartTime, "HHmmss") & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "DTEND;TZID=Eastern Time:" & #DateFormat(getEvent.EventDate, "yyyymmdd")# & "T" & TimeFormat(getEvent.Event_EndTime, "HHmmss") & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "SUMMARY:" & #getEvent.ShortTitle# & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "LOCATION:" & #stEvent.EventLocation# & #Variables.CRLF#>
		<cfif getRegistration.WebinarParticipant EQ 0>
			<cfset vCal = #Variables.vCal# & "DESCRIPTION:" & #stEvent.EventDescription# & #Variables.CRLF#>
		<cfelseif getRegistration.WebinarParticipant EQ 1 AND getEvent.WebinarAvailable EQ 1>
			<cfset vCal = #Variables.vCal# & "DESCRIPTION:" & #stEvent.EventDescription# & #Variables.CRLF#>
			<cfset vCal = #Variables.vCal# & "Webinar Information: " & #getEvent.WebinarConnectInfo# & #Variables.CRLF#>
		</cfif>
		<cfset vCal = #Variables.vCal# & "PRIORITY:" & #stEvent.Priority# & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TRANSP:OPAQUE" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "CLASS:PUBLIC" & #Variables.CRLF#>
		<!---
			For a Reminder Use the Below Lines
			<cfset vCal = #Variables.vCal# & "BEGIN:VALARM" & #Variables.CRLF#>
			<cfset vCal = #Variables.vCal# & "TRIGGER:-PT30M" & #Variables.CRLF#>
			<cfset vCal = #Variables.vCal# & "ACTION:DISPLAY" & #Variables.CRLF#>
			<cfset vCal = #Variables.vCal# & "DESCRIPTION:Reminder" & #Variables.CRLF#>
			<cfset vCal = #Variables.vCal# & "END:VALARM" & #Variables.CRLF#>

		--->
		<cfset vCal = #Variables.vCal# & "END:VEVENT" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "END:VCALENDAR" & #Variables.CRLF#>
		<cfreturn Trim(variables.vcal)>
	</cffunction>

	<cffunction name="UpcomingEventsForDigitalSignage" ReturnType="xml" Access="Remote" Output="False"  hint="Returns Upcoming Events">
		<cfargument name="DaysInFuture" required="true" type="Number">
		<cfargument name="SiteID" required="true" type="String">

		<cfset DateInFuture = #DateFormat(DateAdd("d", Now(), Arguments.DaysInFuture), "yyyy-mm-dd")#>
		<cfset TodayDate = #DateFormat(Now(), "yyyy-mm-dd")#>

		<cfquery name="getEvent" Datasource="NIESCEventRegistration" username="CFAppsMySQL" password="CFAppsMySQL">
			Select eEvents.TContent_ID, eEvents.ShortTitle, eEvents.EventDate, eEvents.LongDescription
			From eEvents
			Where eEvents.EventDate > <cfqueryparam value="#Variables.TodayDate#" cfsqltype="cf_sql_date"> and
				eEvents.EventDate < <cfqueryparam value="#Variables.DateInFuture#" cfsqltype="cf_sql_date"> and
				eEvents.Site_ID = <cfqueryparam value="#Arguments.SiteID#" cfsqltype="cf_sql_varchar"> and
				eEvents.Active = 1
			Order by EventDate ASC
		</cfquery>

		<cfif getEvent.RecordCount>
			<cfsavecontent variable="xmlData">
			<?xml version="1.0" encoding="UTF-8"?>
			<cfoutput><UpComingEvents>
				<cfloop query="getEvent">
					<cfset ReplacedString = #Replace(getEvent.LongDescription, "&", "and")#>
					<cfset ReplacedString = #Replace(Variables.ReplacedString, "/", "")#>
				<Event ID="#getEvent.TContent_ID#">
					<DateOfEvent>#DateFormat(getEvent.EventDate, "mm-dd-yyyy")#</DateOfEvent>
					<EventTitle>#getEvent.ShortTitle#</EventTitle>
					<EventText>#Variables.ReplacedString#</EventText>
					<EventRegisterQRCode>http://events.niesc.k12.in.us/?info=#getEvent.TContent_ID#</EventRegisterQRCode>
				</Event>
				</cfloop>
			</UpComingEvents></cfoutput>
			</cfsavecontent>
			<cfreturn RTrim(LTrim(Variables.xmlData))>
		</cfif>
	</cffunction>

	<cffunction name="UpcomingEvents" ReturnType="xml" Access="Remote" Output="False"  hint="Returns Upcoming Events">
		<cfargument name="DaysInFuture" required="true" type="Number">
		<cfargument name="SiteID" required="true" type="String">

		<cfset DateInFuture = #DateFormat(DateAdd("d", Now(), Arguments.DaysInFuture), "yyyy-mm-dd")#>
		<cfset TodayDate = #DateFormat(Now(), "yyyy-mm-dd")#>

		<cfquery name="getEvent" Datasource="NIESCEventRegistration" username="CFAppsMySQL" password="CFAppsMySQL">
			Select TContent_ID, ShortTitle, EventDate
			From p_EventRegistration_Events
			Where EventDate > <cfqueryparam value="#Variables.TodayDate#" cfsqltype="cf_sql_date"> and
				EventDate < <cfqueryparam value="#Variables.DateInFuture#" cfsqltype="cf_sql_date"> and
				Site_ID = <cfqueryparam value="#Arguments.SiteID#" cfsqltype="cf_sql_varchar"> and
				Active = 1
			Order by EventDate ASC
		</cfquery>

		<cfif getEvent.RecordCount>
			<cfsavecontent variable="xmlData">
				<cfoutput><?xml version="1.0" encoding="UTF-8"?><Events CF_TYPE='array'><cfloop query="getEvent"><Event ID="#getEvent.TContent_ID#" CF_TYPE="query"><DateOfEvent>#DateFormat(getEvent.EventDate, "mm-dd-yyyy")#</DateOfEvent><EventTitle>#getEvent.ShortTitle#</EventTitle><EventID>#getEvent.TContent_ID#</EventID></Event></cfloop></Events></cfoutput>
			</cfsavecontent>
			<cfreturn RTrim(LTrim(Variables.xmlData))>
		<cfelse>
			<cfsavecontent variable="xmlData">
			<?xml version="1.0" encoding="UTF-8"?>
			<cfoutput><UpComingEvents>
				<NumberEvents>0</NumberEvents>
				<EventInfo></EventInfo>
			</UpComingEvents></cfoutput>
			</cfsavecontent>
			<cfreturn RTrim(LTrim(Variables.xmlData))>
		</cfif>
	</cffunction>

	<cffunction name="AddParticipantToDatabase" Access="Remote" returntype="Any" output="true" hint="Add Participant To Database">
		<cfset requestData = getHttpRequestData()>
		<cfset requestContent = #variables.requestData.content#>
		<cfset requestContent = #Replace(variables.requestContent, "%7B", "{", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%22", '"', "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%3A", ":", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%2C", ",", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%2F", "/", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%7D", "}", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%40", "@", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%20", " ", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%2B", " ", "ALL")#>
		<cfset Info = #ListLast(ListLast(variables.requestContent, "&"), "=")#>
		<cfset requestinfo = #DeserializeJSON(Info)#>
		
		<cfquery name="CheckAccount" Datasource="#requestinfo.DBInfo.Datasource#" username="#requestinfo.DBInfo.DBUsername#" password="#requestinfo.DBInfo.DBPassword#">
			Select UserID, Fname, Lname, Email
			From tusers
			Where UserName = <cfqueryparam value="#requestinfo.UserInfo.Email#" cfsqltype="cf_sql_varchar">
			Order by Lname, Fname
		</cfquery>

		<cfif CheckAccount.RecordCount EQ 0>
			<cfset NewUser = #Application.userManager.readByUsername(requestinfo.UserInfo.Email, requestinfo.DBInfo.SiteID)#>
			<cfset NewUser.setInActive(1)>
			<cfset NewUser.setSiteID('NIESCEvents')>
			<cfset NewUser.setFname(Replace(requestinfo.UserInfo.Fname, "+", " ", "ALL"))>
			<cfset NewUser.setLname(Replace(requestinfo.UserInfo.Lname, "+", " ", "ALL"))>
			<cfset NewUser.setUsername(requestinfo.UserInfo.Email)>
			<cfset NewUser.setEmail(requestinfo.UserInfo.Email)>
			<cfset AddNewAccount = #Application.userManager.save(NewUser)#>
			<cfset NewUserAccountID = #Variables.AddNewAccount.GetUserID()#>

			<cfif RequestInfo.DBInfo.EmailConfirmations EQ true>
				<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(requestinfo.DBInfo.PackageName)#/library/components/EmailServices")>
				<cfset temp = #SendEmailCFC.SendAccountActivationEmailFromOrganizationPerson(requestinfo, NewUserAccountID)#>
			</cfif>
			<cfreturn SerializeJSON(True)>
		<cfelse>
			<cfreturn SerializeJSON(FALSE)>
		</cfif>
	</cffunction>

	<cffunction name="generateShortLink" returntype="string">
		<cfargument name="length" type="Numeric" required="true" default="6">
		<cfset var local=StructNew()>

		<!--- create a list of all allowable characters for our short URL link --->
		<cfset local.chars="A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9,-">
		<!--- our radix is the total number of possible characters --->
		<cfset local.radix=listlen(local.chars)>
		<!--- initialise our return variable --->
		<cfset local.shortlink="">

		<!--- loop from 1 until the number of characters our URL should be, adding a random character from our master list on each iteration  --->
		<cfloop from="1" to="#arguments.length#" index="i">
			<!--- generate a random number in the range of 1 to the total number of possible characters we have defined --->
			<cfset local.randnum=RandRange(1,local.radix)>
			<!--- add the character from a random position in our list to our short link --->
			<cfset local.shortlink=local.shortlink & listGetAt(local.chars,local.randnum)>
		</cfloop>
		<!--- return the generated random short link --->
		<cfreturn local.shortlink>
	</cffunction>

	<cffunction name="insertShortURLContent" returntype="any">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="link" type="String" required="true">
		<cfset var result=StructNew()>

		<!--- begin our error-catching block --->
		<cftry>
			<!--- try to insert the new link into the database --->
			<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#" name="result.qry" result="result.stats">
				INSERT INTO p_EventRegistration_ShortURL(Site_ID, FullLink, ShortLink, Active, dateCreated, lastUpdated)
				VALUES(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.link#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#generateShortLink()#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
			</cfquery>

			<!--- try to return the new shortlink value, referencing the last returned identifier --->
			<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#" name="result.inserted">
				SELECT ShortLink
				FROM p_EventRegistration_ShortURL
				WHERE
					TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result.stats.GENERATED_KEY#">
			</cfquery>

			<cfcatch>
				<!--- insert was not successful - the shortlink generated was not unqiue, so set the return variable to an empty string --->
				<cfset result.inserted.cfdump = #CFCATCH#>
				<cfset result.inserted.shortlink="">
				<cfreturn result.inserted>
			</cfcatch> 
		</cftry>		

		<!--- return either the newly created shortlink, or an empty string if an error occurred --->
		<cfreturn result.inserted.ShortLink> 
	</cffunction>
	
	<cffunction name="getFullLinkFromShortURL" returntype="string">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="shortlink" type="string" required="true">
		<cfset var result="">
		<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#" name="result">
			SELECT TContent_ID, FullLink
			FROM p_EventRegistration_ShortURL
			WHERE ShortLink = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.shortlink#"> and Active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		</cfquery>

		<cfif Result.RecordCount>
			<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Update p_EventRegistration_ShortURL
				Set Active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
					LastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result.TContent_ID#">
			</cfquery>
			<cfreturn result.FullLink>
		<cfelse>
			<cfreturn "The ShortURL Link is not valid">
		</cfif>
	</cffunction>

</cfcomponent>
