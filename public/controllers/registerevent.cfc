/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent output="false" persistent="false" accessors="true">

	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID") and isNumeric(URL.EventID) and Session.Mura.IsLoggedIn EQ "false">
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfif isDefined("Session.UserRegistrationInfo")>
					<cfset Session.UserRegistrationInfo.EventID = #URL.EventID#>
					<cfset Session.UserRegistrationInfo.DateRegistered = #Now()#>
					<cfset Session.UserRegistrationInfo.UserEmailDomain = #Right(Session.Mura.EMail, Len(Session.Mura.Email) - Find("@", Session.Mura.Email))#>
				<cfelse>
					<cfset Session.UserRegistrationInfo = StructNew()>
					<cfset Session.UserRegistrationInfo.EventID = #URL.EventID#>
					<cfset Session.UserRegistrationInfo.DateRegistered = #Now()#>
					<cfset Session.UserRegistrationInfo.UserEmailDomain = #Right(Session.Mura.EMail, Len(Session.Mura.Email) - Find("@", Session.Mura.Email))#>
				</cfif>
			</cflock>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>

			<cfquery name="Session.getActiveMembership" datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, OrganizationName, OrganizationDomainName, Active
				From p_EventRegistration_Membership
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					OrganizationDomainName = <cfqueryparam value="#Session.UserRegistrationInfo.UserEmailDomain#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfif Session.getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
				<cfif DateDiff("d", Now(), getSelectedEvent.EarlyBird_RegistrationDeadline) GTE 0>
					<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = True>
				<cfelse>
					<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = False>
				</cfif>
			<cfelse>
				<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = False>
			</cfif>

			<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
				<cfset Session.UserRegistrationInfo.WebinarPricingAvailable = True>
				<cfif Session.getActiveMembership.RecordCount GTE 1>
					<cfset Session.UserRegistrationInfo.WebinarPricingEventCost = #Session.getSelectedEvent.WebinarMemberCost#>
				<cfelse>
					<cfset Session.UserRegistrationInfo.WebinarPricingEventCost = #Session.getSelectedEvent.WebinarNonMemberCost#>
				</cfif>
			<cfelse>
				<cfset Session.UserRegistrationInfo.WebinarPricingAvailable = False>
			</cfif>

			<cfif Session.getSelectedEvent.AllowVideoConference EQ 1>
				<cfset Session.UserRegistrationInfo.VideoConferenceOption = True>
				<cfset Session.UserRegistrationInfo.VideoConferenceInfo = #Session.getSelectedEvent.VideoConferenceInfo#>
				<cfif Session.getActiveMembership.RecordCount GTE 1>
					<cfset Session.UserRegistrationInfo.VideoConferenceCost = #Session.getSelectedEvent.VideoConferenceCost#>
				<cfelse>
					<cfset Session.UserRegistrationInfo.VideoConferenceCost = #Session.getSelectedEvent.VideoConferenceCost#>
				</cfif>
			<cfelse>
				<cfset Session.UserRegistrationInfo.VideoConferenceOption = False>
			</cfif>

			<cfif Session.getSelectedEvent.ViewSpecialPricing EQ 1>
				<cfset Session.UserRegistrationInfo.SpecialPricingAvailable = True>
			<cfelse>
				<cfset Session.UserRegistrationInfo.SpecialPricingAvailable = False>
			</cfif>

			<cfif Session.getActiveMembership.RecordCount EQ 1>
				<cfset Session.UserRegistrationInfo.UserGetsMembershipPrice = True>
				<cfset Session.UserRegistrationInfo.UserEventPrice = #Session.getSelectedEvent.MemberCost#>
				<cfset Session.UserRegistrationInfo.SpecialEventPrice = #Session.getSelctedEvent.SpecialMemberCost#>
				<cfset Session.UserRegistrationInfo.UserEventEarlyBirdPrice = #Session.getSelectedEvent.EarlyBird_MemberCost#>
			<cfelse>
				<cfset Session.UserRegistrationInfo.UserGetsMembershipPrice = False>
				<cfset Session.UserRegistrationInfo.UserEventPrice = #Session.getSelectedEvent.NonMemberCost#>
				<cfset Session.UserRegistrationInfo.SpecialEventPrice = #Session.getSelctedEvent.SpecialNonMemberCost#>
				<cfset Session.UserRegistrationInfo.UserEventEarlyBirdPrice = #Session.getSelectedEvent.EarlyBird_NonMemberCost#>
			</cfif>
			<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=action=public:registerevent.default&EventID=#URL.EventID#&display=login">
		<cfelseif isDefined("URL.EventID") and isNumeric(URL.EventID) and Session.Mura.IsLoggedIn EQ "true">
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfif isDefined("Session.UserRegistrationInfo")>
					<cfset Session.UserRegistrationInfo.EventID = #URL.EventID#>
					<cfset Session.UserRegistrationInfo.DateRegistered = #Now()#>
					<cfset Session.UserRegistrationInfo.UserEmailDomain = #Right(Session.Mura.EMail, Len(Session.Mura.Email) - Find("@", Session.Mura.Email))#>
				<cfelse>
					<cfset Session.UserRegistrationInfo = StructNew()>
					<cfset Session.UserRegistrationInfo.EventID = #URL.EventID#>
					<cfset Session.UserRegistrationInfo.DateRegistered = #Now()#>
					<cfset Session.UserRegistrationInfo.UserEmailDomain = #Right(Session.Mura.EMail, Len(Session.Mura.Email) - Find("@", Session.Mura.Email))#>
				</cfif>

				<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
					From p_EventRegistration_Events
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
						EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
				</cfquery>

				<cfquery name="Session.getActiveMembership" datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, OrganizationName, OrganizationDomainName, Active
					From p_EventRegistration_Membership
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						OrganizationDomainName = <cfqueryparam value="#Session.UserRegistrationInfo.UserEmailDomain#" cfsqltype="cf_sql_varchar">
				</cfquery>

				<cfif Session.getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
					<cfif DateDiff("d", Now(), getSelectedEvent.EarlyBird_RegistrationDeadline) GTE 0>
						<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = True>
					<cfelse>
						<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = False>
					</cfif>
				<cfelse>
					<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = False>
				</cfif>

				<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
					<cfset Session.UserRegistrationInfo.WebinarPricingAvailable = True>
					<cfif Session.getActiveMembership.RecordCount GTE 1>
						<cfset Session.UserRegistrationInfo.WebinarPricingEventCost = #Session.getSelectedEvent.WebinarMemberCost#>
					<cfelse>
						<cfset Session.UserRegistrationInfo.WebinarPricingEventCost = #Session.getSelectedEvent.WebinarNonMemberCost#>
					</cfif>
				<cfelse>
					<cfset Session.UserRegistrationInfo.WebinarPricingAvailable = False>
				</cfif>

				<cfif Session.getSelectedEvent.ViewSpecialPricing EQ 1>
					<cfset Session.UserRegistrationInfo.SpecialPricingAvailable = True>
				<cfelse>
					<cfset Session.UserRegistrationInfo.SpecialPricingAvailable = False>
				</cfif>

				<cfif Session.getSelectedEvent.AllowVideoConference EQ 1>
					<cfset Session.UserRegistrationInfo.VideoConferenceOption = True>
					<cfset Session.UserRegistrationInfo.VideoConferenceInfo = #Session.getSelectedEvent.VideoConferenceInfo#>
					<cfif Session.getActiveMembership.RecordCount GTE 1>
						<cfset Session.UserRegistrationInfo.VideoConferenceCost = #Session.getSelectedEvent.VideoConferenceCost#>
					<cfelse>
						<cfset Session.UserRegistrationInfo.VideoConferenceCost = #Session.getSelectedEvent.VideoConferenceCost#>
					</cfif>
				<cfelse>
					<cfset Session.UserRegistrationInfo.VideoConferenceOption = False>
				</cfif>

				<cfif Session.getActiveMembership.RecordCount EQ 1>
					<cfset Session.UserRegistrationInfo.UserGetsMembershipPrice = True>
					<cfset Session.UserRegistrationInfo.UserEventPrice = #Session.getSelectedEvent.MemberCost#>
					<cfset Session.UserRegistrationInfo.SpecialEventPrice = #Session.getSelectedEvent.SpecialMemberCost#>
					<cfset Session.UserRegistrationInfo.UserEventEarlyBirdPrice = #Session.getSelectedEvent.EarlyBird_MemberCost#>
				<cfelse>
					<cfset Session.UserRegistrationInfo.UserGetsMembershipPrice = False>
					<cfset Session.UserRegistrationInfo.UserEventPrice = #Session.getSelectedEvent.NonMemberCost#>
					<cfset Session.UserRegistrationInfo.SpecialEventPrice = #Session.getSelectedEvent.SpecialNonMemberCost#>
					<cfset Session.UserRegistrationInfo.UserEventEarlyBirdPrice = #Session.getSelectedEvent.EarlyBird_NonMemberCost#>
				</cfif>
			</cflock>
		</cfif>

		<cfif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>

			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "UserRegistrationInfo")>
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getActiveMembership")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default" addtoken="false">
			</cfif>

			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfset CreateiCalCard = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>

		</cfif>
	</cffunction>

</cfcomponent>