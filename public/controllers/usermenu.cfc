/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

	</cffunction>

	<cffunction name="manageregistrations" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.GetRegisteredEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5,
					p_EventRegistration_Events.Presenters, p_EventRegistration_Events.Event_StartTime, p_EventRegistration_Events.Event_EndTime, p_EventRegistration_Events.Registration_Deadline, p_EventRegistration_Events.LongDescription, p_EventRegistration_Events.EventAgenda,
					p_EventRegistration_Events.EventTargetAudience, p_EventRegistration_Events.EventStrategies, p_EventRegistration_Events.EventSpecialInstructions, p_EventRegistration_Events.PGPAvailable, p_EventRegistration_Events.MealProvided, p_EventRegistration_Events.WebinarAvailable,
					p_EventRegistration_Events.WebinarConnectInfo, p_EventRegistration_Events.WebinarMemberCost, p_EventRegistration_Events.WebinarNonMemberCost, p_EventRegistration_Events.LocationID, p_EventRegistration_Events.LocationRoomID,
					p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
					p_EventRegistration_UserRegistrations.RegistrationID,  p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_UserRegistrations.EventID, p_EventRegistration_Events.PGPAvailable, p_EventRegistration_Events.PGPPoints
				FROM p_EventRegistration_UserRegistrations INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				WHERE p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
				ORDER BY p_EventRegistration_UserRegistrations.RegistrationDate DESC
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="cancelregistration" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5,
					p_EventRegistration_Events.Presenters, p_EventRegistration_Events.Event_StartTime, p_EventRegistration_Events.Event_EndTime, p_EventRegistration_Events.Registration_Deadline, p_EventRegistration_Events.LongDescription, p_EventRegistration_Events.EventAgenda,
					p_EventRegistration_Events.EventTargetAudience, p_EventRegistration_Events.EventStrategies, p_EventRegistration_Events.EventSpecialInstructions, p_EventRegistration_Events.PGPAvailable, p_EventRegistration_Events.MealProvided, p_EventRegistration_Events.WebinarAvailable,
					p_EventRegistration_Events.WebinarConnectInfo, p_EventRegistration_Events.WebinarMemberCost, p_EventRegistration_Events.WebinarNonMemberCost, p_EventRegistration_Events.LocationID, p_EventRegistration_Events.LocationRoomID,
					p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
					p_EventRegistration_UserRegistrations.RegistrationID,  p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_UserRegistrations.EventID, p_EventRegistration_Events.PGPAvailable, p_EventRegistration_Events.PGPPoints
				FROM p_EventRegistration_UserRegistrations INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				WHERE p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
					p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
				ORDER BY p_EventRegistration_UserRegistrations.RegistrationDate DESC
			</cfquery>
			<cfif LEN(Session.GetSelectedEvent.Presenters)>
				<cfquery name="Session.EventPresenter" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select FName, LName
					From tusers
					Where UserID = <cfqueryparam value="#Session.GetSelectedEvent.Presenters#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>
			<cfif Session.GetSelectedEvent.LocationID GT 0>
				<cfquery name="Session.GetEventFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, GeoCode_Latitude, GeoCode_Longitude
					From p_EventRegistration_Facility
					Where TContent_ID = <cfqueryparam value="#Session.GetSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="Session.GetEventFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select RoomName
					From p_EventRegistration_FacilityRooms
					Where Facility_ID = <cfqueryparam value="#Session.GetSelectedEvent.LocationID#" cfsqltype="cf_sql_integer"> and
						TContent_ID = <cfqueryparam value="#Session.GetSelectedEvent.LocationRoomID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif FORM.UserAction EQ "Back to Manage Registrations">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "GetSelectedEvent")>
				<cfset temp = StructDelete(Session, "GetEventFacility")>
				<cfset temp = StructDelete(Session, "GetEventFacilityRoom")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.manageregistrations" addtoken="false">
			</cfif>

			<cfif FORM.CancelRegistration EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Do you want to cancel your registration for this event? Select Yes or No below."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.cancelregistration&EventID=#FORM.EventID#&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.CancelRegistration EQ 1>
				<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
				<cfset Info = StructNew()>
				<cfset Info.RegistrationID = #Session.GetSelectedEvent.RegistrationID#>
				<cfset Info.FormData = #StructCopy(Session.FormData)#>
				<cfset temp = #SendEmailCFC.SendEventCancellationToSingleParticipant(rc, Variables.Info)#>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.manageregistrations&RegistrationCancelled=True" addtoken="false">
			<cfelse>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.manageregistrations&EventID=#FORM.EventID#&RegistrationCancelled=False" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="getcertificate" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("URL.EventID")>
			<cfquery name="Session.GetRegisteredEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5,
					p_EventRegistration_Events.Presenters, p_EventRegistration_Events.Event_StartTime, p_EventRegistration_Events.Event_EndTime, p_EventRegistration_Events.Registration_Deadline, p_EventRegistration_Events.LongDescription, p_EventRegistration_Events.EventAgenda,
					p_EventRegistration_Events.EventTargetAudience, p_EventRegistration_Events.EventStrategies, p_EventRegistration_Events.EventSpecialInstructions, p_EventRegistration_Events.PGPAvailable, p_EventRegistration_Events.MealProvided, p_EventRegistration_Events.WebinarAvailable,
					p_EventRegistration_Events.WebinarConnectInfo, p_EventRegistration_Events.WebinarMemberCost, p_EventRegistration_Events.WebinarNonMemberCost, p_EventRegistration_Events.LocationID, p_EventRegistration_Events.LocationRoomID,
					p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
					p_EventRegistration_UserRegistrations.RegistrationID,  p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_UserRegistrations.EventID, p_EventRegistration_Events.PGPAvailable, p_EventRegistration_Events.PGPPoints
				FROM p_EventRegistration_UserRegistrations INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				WHERE p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
					p_EventRegistration_Events.PGPAvailable = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				ORDER BY p_EventRegistration_UserRegistrations.RegistrationDate DESC
			</cfquery>
		<cfelseif isDefined("URL.EventID") and isDefined("URL.DisplayCertificate")>
			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_Events.TContent_ID, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.PGPPoints, tusers.Fname, tusers.Lname
				FROM p_EventRegistration_UserRegistrations INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				INNER JOIN tusers on tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
				WHERE p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
					p_EventRegistration_Events.PGPAvailable = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					p_EventRegistration_Events.TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfset CurLoc = #ExpandPath("/")#>
			<cfset CertificateTemplateDir = #Variables.CurLoc# & "plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/">
			<cfset CertificateExportTemplateDir = #Variables.CurLoc# & "plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/">
			<cfset CertificateMasterTemplate = #Variables.CertificateTemplateDir# & "NIESCRisePGPCertificateTemplate.pdf">
			<cfset ParticipantName = #GetSelectedEvent.FName# & " " & #GetSelectedEvent.LName#>
			<cfset ParticipantFilename = #Replace(Variables.ParticipantName, " ", "", "all")#>
			<cfset ParticipantFilename = #Replace(Variables.ParticipantFilename, ".", "", "all")#>
			<cfset PGPEarned = "PGP Earned: " & #NumberFormat(GetSelectedEvent.PGPPoints, "99.9")#>
			<cfset CertificateCompletedFile = #Variables.CertificateExportTemplateDir# & #GetSelectedEvent.TContent_ID# & "-" & #Variables.ParticipantFilename# & ".pdf">
			<cfset Session.CertificateCompletedFile = "/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/" & #GetSelectedEvent.TContent_ID# & "-" & #Variables.ParticipantFilename# & ".pdf">
			<cfscript>
				PDFCompletedCertificate = CreateObject("java", "java.io.FileOutputStream").init(CertificateCompletedFile);
				PDFMasterCertificateTemplate = CreateObject("java", "com.itextpdf.text.pdf.PdfReader").init(CertificateMasterTemplate);
				PDFStamper = CreateObject("java", "com.itextpdf.text.pdf.PdfStamper").init(PDFMasterCertificateTemplate, PDFCompletedCertificate);
				PDFStamper.setFormFlattening(true);
				PDFFormFields = PDFStamper.getAcroFields();
				PDFFormFields.setField("PGPEarned", Variables.PGPEarned);
				PDFFormFields.setField("ParticipantName", Variables.ParticipantName);
				PDFFormFields.setField("EventTitle", GetSelectedEvent.ShortTitle);
				PDFFormFields.setField("EventDate", DateFormat(GetSelectedEvent.EventDate, "full"));
				PDFFormFields.setField("SignDate", DateFormat(GetSelectedEvent.EventDate, "mm/dd/yyyy"));
				PDFStamper.close();
			</cfscript>

		</cfif>

	</cffunction>







	<cffunction name="editprofile" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and not isDefined("URL.FormRetry")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif not isDefined("Session.FormData.PluginInfo")>
				<cfset Session.FormData.PluginInfo = StructNew()>
				<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
				<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
				<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
				<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
				<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
			</cfif>

			<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.editprofile&FormRetry=True">
			</cfif>

			<cfif not isValid("email", FORM.Email)>
				<cfscript>
					UsernameNotValid = {property="Email",message="The Email Address is not a valid email address. We use this to lookup your account so that the correct information can be sent to you."};
					arrayAppend(Session.FormErrors, UsernameNotValid);
				</cfscript>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.editprofile&FormRetry=True">
			</cfif>

			<cfquery name="getSelectedSchoolDistrict" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select OrganizationName, StateDOE_IDNumber
				From eMembership
				Where StateDOE_IDNumber = <cfqueryparam value="#FORM.Company#" cfsqltype="cf_sql_varchar"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfquery name="getOrigionalUserValues" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select fName, LName, Email, Company, JobTitle, mobilePhone
				From tusers
				Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfparam name="UserEditProfile" type="boolean" default="0">

			<cfif Session.FormData.fName NEQ getOrigionalUserValues.FName>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set fName = <cfqueryparam value="#Session.FormData.FName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.lName NEQ getOrigionalUserValues.FName>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set lName = <cfqueryparam value="#Session.FormData.LName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.Email NEQ getOrigionalUserValues.EMail>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set EMail = <cfqueryparam value="#Session.FormData.Email#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.Company NEQ getOrigionalUserValues.Company>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set Company = <cfqueryparam value="#getSelectedSchoolDistrict.OrganizationName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.JobTitle NEQ getOrigionalUserValues.JobTitle>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set JobTitle = <cfqueryparam value="#Session.FormData.JobTitle#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.mobilePhone NEQ getOrigionalUserValues.mobilePhone>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set mobilePhone = <cfqueryparam value="#Session.FormData.mobilePhone#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Variables.UserEditProfile EQ 1>
				<cfset Session.Mura.Company = #getSelectedSchoolDistrict.OrganizationName#>
				<cfset Session.Mura.fName = #Session.FormData.fName#>
				<cfset Session.Mura.lName = #Session.FormData.lName#>
				<cfset Session.Mura.Email = #Session.FormData.Email#>
				<cflocation addtoken="true" url="/?UserProfileUpdateSuccessfull=True">
			<cfelse>
				<cflocation addtoken="true" url="/?">
			</cfif>

		<cfelseif isDefined("FORM.formSubmit") and isDefined("URL.FormRetry")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif not isDefined("Session.FormData.PluginInfo")>
				<cfset Session.FormData.PluginInfo = StructNew()>
				<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
				<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
				<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
				<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
				<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
			</cfif>

			<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.editprofile&FormRetry=True">
			</cfif>

			<cfif not isValid("email", FORM.Email)>
				<cfscript>
					UsernameNotValid = {property="Email",message="The Email Address is not a valid email address. We use this to lookup your account so that the correct information can be sent to you."};
					arrayAppend(Session.FormErrors, UsernameNotValid);
				</cfscript>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.editprofile&FormRetry=True">
			</cfif>

			<cfquery name="getSelectedSchoolDistrict" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select OrganizationName, StateDOE_IDNumber
				From eMembership
				Where StateDOE_IDNumber = <cfqueryparam value="#FORM.Company#" cfsqltype="cf_sql_varchar"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfquery name="getOrigionalUserValues" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select fName, LName, Email, Company, JobTitle, mobilePhone
				From tusers
				Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfparam name="UserEditProfile" type="boolean" default="0">

			<cfif Session.FormData.fName NEQ getOrigionalUserValues.FName>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set fName = <cfqueryparam value="#Session.FormData.FName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.lName NEQ getOrigionalUserValues.FName>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set lName = <cfqueryparam value="#Session.FormData.LName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.Email NEQ getOrigionalUserValues.EMail>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set EMail = <cfqueryparam value="#Session.FormData.Email#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.Company NEQ getOrigionalUserValues.Company>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set Company = <cfqueryparam value="#getSelectedSchoolDistrict.OrganizationName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.JobTitle NEQ getOrigionalUserValues.JobTitle>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set JobTitle = <cfqueryparam value="#Session.FormData.JobTitle#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.mobilePhone NEQ getOrigionalUserValues.mobilePhone>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set mobilePhone = <cfqueryparam value="#Session.FormData.mobilePhone#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Variables.UserEditProfile EQ 1>
				<cfset Session.Mura.Company = #getSelectedSchoolDistrict.OrganizationName#>
				<cfset Session.Mura.fName = #Session.FormData.fName#>
				<cfset Session.Mura.lName = #Session.FormData.lName#>
				<cfset Session.Mura.Email = #Session.FormData.Email#>
				<cflocation addtoken="true" url="/?UserProfileUpdateSuccessfull=True">
			<cfelse>
				<cflocation addtoken="true" url="/?">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="lostpassword" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

		<cfif isDefined("FORM.formSubmit") and not isDefined("form.formSendTemporaryPassword")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif not isDefined("Session.FormData.PluginInfo")>
				<cfset Session.FormData.PluginInfo = StructNew()>
				<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
				<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
				<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
				<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
				<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
			</cfif>

			<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.lostpassword&FormRetry=True">
			</cfif>

			<cfif not isValid("email", FORM.Email)>
				<cfscript>
					UsernameNotValid = {property="Email",message="The Email Address is not a valid email address. We use this to lookup your account so that the correct information can be sent to you."};
					arrayAppend(Session.FormErrors, UsernameNotValid);
				</cfscript>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.lostpassword&FormRetry=True">
			</cfif>

			<cfquery name="GetAccountUsername" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
				Select Fname, Lname, UserName, Email, created
				From tusers
				Where Email = <cfqueryparam value="#FORM.Email#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#Session.FormData.PluginInfo.SiteID#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfif GetAccountUsername.RecordCount EQ 0>
				<cfscript>
					UsernameNotValid = {property="Email",message="The Email Address was not located within the database as a valid account. We use this to lookup your account so that the correct information can be sent to you."};
					arrayAppend(Session.FormErrors, UsernameNotValid);
				</cfscript>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.lostpassword&FormRetry=True">
			</cfif>

			<cfset Temp = #SendEmailCFC.SendLostPasswordVerifyFormToUser(FORM.Email)#>
			<cflocation addtoken="true" url="/?UserAccountPasswordVerify=True">
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.formSendTemporaryPassword")>
			<cfquery name="GetAccountUsername" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
				Select Fname, Lname, UserName, Email, created
				From tusers
				Where Email = <cfqueryparam value="#FORM.UserAccountEmail#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#Session.FormData.PluginInfo.SiteID#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfif not isDefined("Session.FormData.PluginInfo")>
				<cfset Session.FormData.PluginInfo = StructNew()>
				<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
				<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
				<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
				<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
				<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
			</cfif>
			<cfif FORM.formSubmit EQ "true" and FORM.formSendTemporaryPassword EQ "true">
				<cfif FORM.SendTempPassword EQ 1>
					<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
								arrayAppend(Session.FormErrors, errormsg);
							</cfscript>
						</cflock>
						<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.lostpassword&FormRetry=True&Key=#FORM.Key#">
					</cfif>
					<cfset Temp = #SendEmailCFC.SendTemporaryPasswordToUser(FORM.UserAccountEmail)#>
					<cflocation addtoken="true" url="/?UserAccountPasswordSent=True">
				<cfelse>
					<cflocation addtoken="true" url="/?UserAccountNotModified=True">
				</cfif>
			</cfif>

		</cfif>
	</cffunction>








	<cffunction name="changepassword" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("form.UserID")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif not isDefined("Session.FormData.PluginInfo")>
				<cfset Session.FormData.PluginInfo = StructNew()>
				<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
				<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
				<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
				<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
				<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
			</cfif>

			<cfquery name="getAccountPassword" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Username, fname, lname, password
				From tusers
				Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfif Application.serviceFactory.getBean("utility").checkBCryptHash(FORM.oldPassword,getAccountPassword.password) EQ true OR (Hash(form.oldPassword) eq getAccountPassword.password)>
				<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
					</cflock>
					<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.changepassword&FormRetry=True">
				</cfif>

				<cfif FORM.newPassword NEQ FORM.newVerifyPassword>
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							errormsg = {property="newPassword",message="The new desired password did not match the verify desired password. Both of these password fields must match in order to change your password."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
					</cflock>
					<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.changepassword&FormRetry=True">
				</cfif>

				<cftry>
					<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
						Update tusers
						Set password = <cfqueryparam value="#Application.serviceFactory.getBean('utility').toBCryptHash(FORM.newPassword)#" cfsqltype="cf_sql_varchar">
						Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cflocation addtoken="true" url="/?UserPasswordChangeSuccessfull=True">
					<cfcatch type="any">
						<cflocation addtoken="true" url="/?UserPasswordChangeSuccessfull=False">
					</cfcatch>
				</cftry>
			<cfelse>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="oldPassword",message="The Current Password does not match what is stored in the database. Please try entering your current password again."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.changepassword&FormRetry=True">
			</cfif>

		</cfif>
	</cffunction>

</cfcomponent>