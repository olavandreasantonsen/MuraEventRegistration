<cfif not isDefined("URL.EventID")>
	<cfoutput>
		<div class="panel panel-default">
			<div class="panel-heading"><h2>List of Registered Events</h2></div>
			<div class="panel-body">
				<cfif isDefined("URL.RegistrationCancelled")>
					<cfswitch expression="#URL.RegistrationCancelled#">
						<cfcase value="True">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Registration cancelled</h3>
										</div>
										<div class="modal-body">
											<div class="alert alert-danger">The registration for #Session.GetSelectedEvent.ShortTitle# was cancelled due to your request.</div>
										</div>
										<div class="modal-footer">
											<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
										</div>
									</div>
								</div>
							</div>
							<script type='text/javascript'>
								(function() {
									'use strict';
									function remoteModal(idModal){
										var vm = this;
										vm.modal = $(idModal);

										if( vm.modal.length == 0 ) { return false; } else { openModal(); }

										if( window.location.hash == idModal ){ openModal(); }

										var services = { open: openModal, close: closeModal };
										return services;
										///////////////

										// method to open modal
										function openModal(){
											vm.modal.modal('show');
										}

										// method to close modal
										function closeModal(){
											vm.modal.modal('hide');
										}
									}
									Window.prototype.remoteModal = remoteModal;
								})();

								$(function(){
									window.remoteModal('##modelWindowDialog');
								});
							</script>
							<cfset temp = StructDelete(Session, "FormErrors")>
							<cfset temp = StructDelete(Session, "FormData")>
							<cfset temp = StructDelete(Session, "GetSelectedEvent")>
							<cfset temp = StructDelete(Session, "GetEventFacility")>
							<cfset temp = StructDelete(Session, "GetEventFacilityRoom")>
						</cfcase>
					</cfswitch>
				</cfif>
				<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
					<tr>
						<td>Event Title</td>
						<td>Primary Date</td>
						<td width="15%"></td>
					</tr>
					<cfif Session.GetRegisteredEvents.RecordCount GTE 1>
						<cfloop query="Session.GetRegisteredEvents">
							<tr>
							<td>#Session.GetRegisteredEvents.ShortTitle#</td>
							<td>#dateFormat(Session.GetRegisteredEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate, "ddd")#)</td>
							<td width="15%"><a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.cancelregistration&EventID=#Session.GetRegisteredEvents.EventID#" class="btn btn-primary btn-small" alt="Event Information">Cancel</a> | <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.GetRegisteredEvents.EventID#" class="btn btn-primary btn-small" alt="Event Information">View</a></td>
							</tr>
						</cfloop>
					<cfelse>
						<tr>
							<td colspan="3" align="center">To view available events you can register for <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default" class="btn btn-primary btn-small" alt="Event Listing Button">click here</a></td>
						</tr>
					</cfif>

				</table>
			</div>
		</div>
	</cfoutput>
<cfelseif isDefined("URL.EventID")>
	<cfoutput>
		<div class="panel panel-default">
			<div class="panel-heading"><h2>List of Registered Events</h2></div>
			<div class="panel-body">
				<cfif isDefined("URL.RegistrationCancelled")>
					<cfswitch expression="#URL.RegistrationCancelled#">
						<cfcase value="False">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Registration not cancelled</h3>
										</div>
										<div class="modal-body">
											<div class="alert alert-danger">The registration for #Session.GetSelectedEvent.ShortTitle# was not cancelled due to your selection.</div>
										</div>
										<div class="modal-footer">
											<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
										</div>
									</div>
								</div>
							</div>
							<script type='text/javascript'>
								(function() {
									'use strict';
									function remoteModal(idModal){
										var vm = this;
										vm.modal = $(idModal);

										if( vm.modal.length == 0 ) { return false; } else { openModal(); }

										if( window.location.hash == idModal ){ openModal(); }

										var services = { open: openModal, close: closeModal };
										return services;
										///////////////

										// method to open modal
										function openModal(){
											vm.modal.modal('show');
										}

										// method to close modal
										function closeModal(){
											vm.modal.modal('hide');
										}
									}
									Window.prototype.remoteModal = remoteModal;
								})();

								$(function(){
									window.remoteModal('##modelWindowDialog');
								});
							</script>
							<cfset temp = StructDelete(Session, "FormErrors")>
							<cfset temp = StructDelete(Session, "FormData")>
							<cfset temp = StructDelete(Session, "GetSelectedEvent")>
							<cfset temp = StructDelete(Session, "GetEventFacility")>
							<cfset temp = StructDelete(Session, "GetEventFacilityRoom")>
						</cfcase>
					</cfswitch>
				</cfif>
				<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
					<tr>
						<td>Event Title</td>
						<td>Primary Date</td>
						<td width="15%"></td>
					</tr>
					<cfloop query="Session.GetRegisteredEvents">
						<tr>
						<td>#Session.GetRegisteredEvents.ShortTitle#</td>
						<td>#dateFormat(Session.GetRegisteredEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate, "ddd")#)</td>
						<td width="15%"><a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.cancelregistration&EventID=#Session.GetRegisteredEvents.EventID#" class="btn btn-primary btn-small" alt="Event Information">Cancel</a> | <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.GetRegisteredEvents.EventID#" class="btn btn-primary btn-small" alt="Event Information">View</a></td>
						</tr>
					</cfloop>
				</table>
			</div>
		</div>
	</cfoutput>
</cfif>