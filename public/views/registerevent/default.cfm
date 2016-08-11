<cfsilent>
	<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
	<cfset temp = QueryAddRow(YesNoQuery, 1)>
	<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
	<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
	<cfset temp = QueryAddRow(YesNoQuery, 1)>
	<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
	<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>

	<cfif Session.getActiveMembership.RecordCount EQ 1>
		<cfset UserActiveMembership = "Yes">
	<cfelse>
		<cfset UserActiveMembership = "No">
	</cfif>
</cfsilent>
<cfoutput>
	<div class="panel panel-default">
		<div class="panel-heading"><h1>Registering for Event: #Session.getSelectedEvent.ShortTitle#</h1></div>
		<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfinput type="hidden" name="EventID" value="#Session.UserRegistrationInfo.EventID#">
			<div class="panel-body">
				<p class="alert alert-info">Please complete the following information to register for this event. All electronic communication from this system will be sent to the Participant's Email Address</p>
				<div class="form-group">
					<label for="RegistrationName" class="control-label col-sm-3">Your Name:&nbsp;</label>
					<div class="col-sm-8"><p class="form-control-static">#Session.Mura.FName# #Session.Mura.LName#</p></div>
				</div>
				<div class="form-group">
					<label for="RegistrationEmail" class="control-label col-sm-3">Your Email:&nbsp;</label>
					<div class="col-sm-8"><p class="form-control-static">#Session.Mura.Email#</p></div>
				</div>
				<cfif Session.getSelectedEvent.PGPAvailable EQ 1>
					<div class="form-group">
						<label for="RegistrationEmail" class="control-label col-sm-3">PGP Points:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#NumberFormat(Session.getSelectedEvent.PGPPoints, "999.99")#</p></div>
					</div>
				</cfif>
				<div class="form-group">
					<label for="EventDate" class="control-label col-sm-3">Active Membership:&nbsp;</label>
					<div class="col-sm-8"><p class="form-control-static">#Variables.UserActiveMembership#</p></div>
				</div>
				<div class="form-group">
					<label for="RegisterAdditionalIndividuals" class="control-label col-sm-3">Register Additional Individuals?:&nbsp;</label>
					<div class="col-sm-8"><cfselect name="RegisterAdditionalIndividuals" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Do you want to Register Additional Individuals</option></cfselect></div>
				</div>
				<cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)>
					<div class="form-group">
					<label for="RegisterAllDates" class="control-label col-sm-3">Register for All Dates?:&nbsp;</label>
					<div class="col-sm-8"><cfselect name="RegisterAllDates" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend all Event Dates</option></cfselect></div>
					</div>
				</cfif>
				<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
					<div class="form-group">
					<label for="AttendViaWebinar" class="control-label col-sm-3">Attend via Webinar?:&nbsp;</label>
					<div class="col-sm-8"><cfselect name="AttendViaWebinar" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend via Webinar Option</option></cfselect></div>
					</div>
					<div class="form-group">
					<label for="RegistrationEmail" class="control-label col-sm-3">Webinar Price:&nbsp;</label>
					<div class="col-sm-8"><p class="form-control-static">#Session.UserRegistrationInfo.WebinarPricingEventCost#</p></div>
					</div>
				<cfelseif Session.getSelectedEvent.WebinarAvailable EQ 0>
					<cfif Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration EQ "True">
						<div class="form-group">
						<label for="RegistrationEmail" class="control-label col-sm-3">Cost to Participate:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.UserRegistrationInfo.UserEventEarlyBirdPrice)#</p></div>
						</div>
					<cfelseif Session.UserRegistrationInfo.SpecialPricingAvailable EQ "True">
						<div class="form-group">
							<p class="alert alert-info">This Pricing will be updated by the Facilitator once the Special Pricing Requirements have been met. If Special Requirements have not been met, then Event Pricing will be #DollarFormat(Session.UserRegistrationInfo.UserEventPrice)# to attend this event.</p>
							<label for="RegistrationEmail" class="control-label col-sm-3">Special Requirements:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.SpecialPriceRequirements#</p></div>
						</div>
						<div class="form-group">
						<label for="RegistrationEmail" class="control-label col-sm-3">Special Pricing:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.UserRegistrationInfo.SpecialEventPrice)#</p></div>
						</div>
					<cfelse>
						<div class="form-group">
						<label for="RegistrationEmail" class="control-label col-sm-3">Cost to Participate:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.UserRegistrationInfo.UserEventPrice)#</p></div>
						</div>
					</cfif>
				</cfif>
				<cfif Session.UserRegistrationInfo.VideoConferenceOption EQ "True">
					<div class="form-group">
					<label for="AttendViaIVC" class="control-label col-sm-3">Attend via Video Conference?:&nbsp;</label>
					<div class="col-sm-8"><cfselect name="AttendViaIVC" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Will you attend via Video Conferencing Equipment</option></cfselect></div>
					</div>
					<div class="form-group">
					<label for="EventDate" class="control-label col-sm-3">Video Conferencing Info:&nbsp;</label>
					<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.VideoConferenceInfo#</p></div>
					</div>
					<div class="form-group">
					<label for="EventDate" class="control-label col-sm-3">Video Conferencing Cost:&nbsp;</label>
					<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.UserRegistrationInfo.VideoConferenceCost)#</p></div>
					</div>
				</cfif>
			</div>
			<div class="panel-footer">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Register For Event"><br /><br />
			</div>
		</cfform>
	</div>
</cfoutput>