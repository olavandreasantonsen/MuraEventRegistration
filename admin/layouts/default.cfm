<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
	<cfsavecontent variable="local.errors">
		<cfif StructKeyExists(rc, 'errors') and IsArray(rc.errors) and ArrayLen(rc.errors)>
			<div class="alert alert-error">
				<button type="button" class="close" data-dismiss="alert"><i class="icon-remove-sign"></i></button>
				<h2>Alert!</h2>
				<h3>Please note the following message<cfif ArrayLen(rc.errors) gt 1>s</cfif>:</h3>
				<ul>
					<cfloop from="1" to="#ArrayLen(rc.errors)#" index="local.e">
						<li>
							<cfif IsSimpleValue(rc.errors[local.e])>
								<cfoutput>#rc.errors[local.e]#</cfoutput>
							<cfelse>
								<cfdump var="#rc.errors[local.e]#" />
							</cfif>
						</li>
						<cfif Session.Mura.IsLoggedIn EQ "true">
							<cfparam name="Session.Mura.EventCoordinatorRole" default="0" type="boolean">
							<cfparam name="Session.Mura.EventPresenterRole" default="0" type="boolean">
							<cfset UserMembershipQuery = #$.currentUser().getMembershipsQuery()#>
							<cfloop query="#Variables.UserMembershipQuery#">
								<cfif UserMembershipQuery.GroupName EQ "Event Facilitator"><cfset Session.Mura.EventCoordinatorRole = true></cfif>
								<cfif UserMembershipQuery.GroupName EQ "Presenter"><cfset Session.Mura.EventPresenterRole = true></cfif>
							</cfloop>
							<cfif Session.Mura.Username EQ "admin">
								<li><a href="/plugins/EventRegistration/" class="active">Event Administration</a>
									<ul>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:caterers.default" class="active">Manage Catering</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:events.default" class="active">Manage Events</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:eventexpenses.default" class="active">Manage Event Expenses</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:facilities.default" class="active">Manage Facilities</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:membership.default" class="active">Manage Membership</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:presenters.default" class="active">Manage Presenters</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:users.default" class="active">Manage Users</a></li>
									</ul>
								</li>
								<li><a href="/plugins/EventRegistration/" class="active">Reporting</a>
									<ul>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:reports.yearendofevents" class="active">YearEnd Report of Events</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:reports.profitlossreport" class="active">Profit/Loss Report of Events</a></li>
									</ul>
								</li>
								<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:sysadmin.default" class="active">System Administration</a>

			<!--- PRIMARY NAV --->
			<div class="row-fluid">
				<div class="navbar navbar-murafw1">
					<div class="navbar-inner">

						<a class="plugin-brand" href="#buildURL('admin:main')#">#HTMLEditFormat(rc.pc.getPackage())#</a>

						<ul class="nav">
							<li class="<cfif rc.action contains 'admin:main'>active</cfif>">
								<a href="##" class="dropdown-toggle" data-toggle="dropdown">Main <b class="caret"></b></a>
								<ul class="dropdown-menu">
									<li class="<cfif rc.action eq 'admin:main.default'>active</cfif>">
										<a href="#buildURL('admin:main')#"><i class="icon-home"></i> Home</a>
									</li>
									<li class="<cfif rc.action contains 'admin:main.another'>active</cfif>">
										<a href="#buildURL('admin:main.another')#"><i class="icon-leaf"></i> Another Page</a>
									</li>
								</ul>
							</li>
							<li class="<cfif rc.action contains 'admin:license'>active</cfif>">
								<a href="#buildURL('admin:license')#"><i class="icon-book"></i> License</a>
							</li>
							<li class="<cfif rc.action contains 'admin:instructions'>active</cfif>">
								<a href="#buildURL('admin:instructions')#"><i class="icon-info-sign"></i> Instructions</a>
							</li>
						</ul><!--- /.nav --->

					</div><!--- /.navbar-inner --->
				</div><!--- /.navbar --->
			</div><!--- /.row --->

			<!--- MAIN CONTENT AREA --->
			<div class="row-fluid">
				<cfif rc.action contains 'admin:main'>

					<!--- SUB-NAV --->
					<div class="span3">
						<ul class="nav nav-list murafw1-sidenav">
							<li class="<cfif rc.action eq 'admin:main.default'>active</cfif>">
								<a href="#buildURL('admin:main')#"><i class="icon-home"></i> Home</a>
							</li>
							<li class="<cfif rc.action eq 'admin:main.another'>active</cfif>">
								<a href="#buildURL('admin:main.another')#"><i class="icon-leaf"></i> Another Page</a>
							</li>
						</ul>
					</div>

					<!--- BODY --->
					<div class="span9">
						#body#
					</div>

				<cfelse>

					<!--- BODY --->
					<div class="span12">
						#body#
					</div>

				</cfif>
			</div><!--- /.row --->
		</div><!--- /.container-murafw1 --->
	</cfoutput>
</cfsavecontent>
<cfoutput>
	#application.pluginManager.renderAdminTemplate(
		body=local.newBody
		,pageTitle=rc.pc.getName()
		,compactDisplay=rc.compactDisplay
	)#
</cfoutput>
