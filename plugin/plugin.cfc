/*

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="mura.plugin.plugincfc" {

	property name="config" type="any" default="";

	public any function init(any config='') {
		setConfig(arguments.config);
	}

	public void function install() {
		// triggered by the pluginManager when the plugin is INSTALLED.
		application.appInitialized = false;

		var dbCheckTables = new query();
		dbCheckTables.setDatasource("#application.configBean.getDatasource()#");
		dbCheckTables.setSQL("Show Tables LIKE 'p_EventRegistration_Membership'");
		var dbCheckTablesResults = dbCheckTables.execute();

		if (dbCheckTablesResults.getResult().recordcount eq 0) {
			// Since the Database Table does not exists, Lets Create it
			var dbCreateTable = new query();
			dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
			dbCreateTable.setSQL("CREATE TABLE `p_EventRegistration_Membership` ( `TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` tinytext NOT NULL, `OrganizationName` varchar(50) NOT NULL, `OrganizationDomainName` varchar(50) NOT NULL, `StateDOE_IDNumber` varchar(10) DEFAULT NULL, `StateDOE_State` tinytext, `Active` bit(1) NOT NULL DEFAULT b'0', `dateCreated` date NOT NULL, `lastUpdateBy` varchar(35) NOT NULL, `lastUpdated` datetime NOT NULL, `Mailing_Address` tinytext, `Mailing_City` tinytext, `Mailing_State` tinytext, `Mailing_ZipCode` tinytext, `Primary_PhoneNumber` tinytext, `Primary_FaxNumber` tinytext, `Physical_Address` tinytext, `Physical_City` tinytext, `Physical_State` tinytext, `Physical_ZipCode` tinytext, `AccountsPayable_EmailAddress` tinytext, `AccountsPayable_ContactName` tinytext, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;");
			var dbCreateTableResults = dbCreateTable.execute();
		} else {
			// Database Table Exists, We must Drop it to create it again
			var dbDropTable = new query();
			dbDropTable.setDatasource("#application.configBean.getDatasource()#");
			dbDropTable.setSQL("DROP TABLE p_EventRegistration_Membership");
			var dbDropTableResults = dbDropTable.execute();

			if (len(dbDropTableResults.getResult()) eq 0) {
				var dbCreateTable = new query();
				dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTable.setSQL("CREATE TABLE `p_EventRegistration_Membership` ( `TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` tinytext NOT NULL, `OrganizationName` varchar(50) NOT NULL, `OrganizationDomainName` varchar(50) NOT NULL, `StateDOE_IDNumber` varchar(10) DEFAULT NULL, `StateDOE_State` tinytext, `Active` bit(1) NOT NULL DEFAULT b'0', `dateCreated` date NOT NULL, `lastUpdateBy` varchar(35) NOT NULL, `lastUpdated` datetime NOT NULL, `Mailing_Address` tinytext, `Mailing_City` tinytext, `Mailing_State` tinytext, `Mailing_ZipCode` tinytext, `Primary_PhoneNumber` tinytext, `Primary_FaxNumber` tinytext, `Physical_Address` tinytext, `Physical_City` tinytext, `Physical_State` tinytext, `Physical_ZipCode` tinytext, `AccountsPayable_EmailAddress` tinytext, `AccountsPayable_ContactName` tinytext, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;");
				var dbCreateTableResults = dbCreateTable.execute();
			} else {

				 writedump(dbDropTableResults.getResult());
				 abort;
			}
		}

		var dbCheckTables = new query();
		dbCheckTables.setDatasource("#application.configBean.getDatasource()#");
		dbCheckTables.setSQL("Show Tables LIKE 'p_EventRegistration_UserMatrix'");
		var dbCheckTablesResults = dbCheckTables.execute();

		if (dbCheckTablesResults.getResult().recordcount eq 0) {
			// Since the Database Table does not exists, Lets Create it
			var dbCreateTable = new query();
			dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
			dbCreateTable.setSQL("CREATE TABLE `p_EventRegistration_UserMatrix` ( `TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` tinytext NOT NULL, `User_ID` char(35) NOT NULL, `School_District` int(11) DEFAULT NULL, `lastUpdateBy` varchar(35) NOT NULL, `lastUpdated` datetime NOT NULL, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;");
			var dbCreateTableResults = dbCreateTable.execute();
		} else {
			// Database Table Exists, We must Drop it to create it again
			var dbDropTable = new query();
			dbDropTable.setDatasource("#application.configBean.getDatasource()#");
			dbDropTable.setSQL("DROP TABLE p_EventRegistration_UserMatrix");
			var dbDropTableResults = dbDropTable.execute();

			if (len(dbDropTableResults.getResult()) eq 0) {
				var dbCreateTable = new query();
				dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTable.setSQL("CREATE TABLE `p_EventRegistration_UserMatrix` ( `TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` tinytext NOT NULL, `User_ID` char(35) NOT NULL, `School_District` int(11) DEFAULT NULL, `lastUpdateBy` varchar(35) NOT NULL, `lastUpdated` datetime NOT NULL, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;");
				var dbCreateTableResults = dbCreateTable.execute();
			} else {

				 writedump(dbDropTableResults.getResult());
				 abort;
			}
		}

		var dbCheckTables = new query();
		dbCheckTables.setDatasource("#application.configBean.getDatasource()#");
		dbCheckTables.setSQL("Show Tables LIKE 'p_EventRegistration_UserRegistrations'");
		var dbCheckTablesResults = dbCheckTables.execute();

		if (dbCheckTablesResults.getResult().recordcount eq 0) {
			// Since the Database Table does not exists, Lets Create it
			var dbCreateTable = new query();
			dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
			dbCreateTable.setSQL("CREATE TABLE `p_EventRegistration_UserRegistrations` ( `TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `RegistrationID` varchar(35) NOT NULL DEFAULT '', `RegistrationDate` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `User_ID` char(35) NOT NULL, `EventID` int(10) NOT NULL DEFAULT '0', `RequestsMeal` bit(1) NOT NULL DEFAULT b'0', `IVCParticipant` bit(1) NOT NULL DEFAULT b'0', `AttendeePrice` double(6,2) DEFAULT '0.00', `RegistrationIPAddr` varchar(15) NOT NULL DEFAULT '0.0.0.0', `RegisterByUserID` varchar(35) NOT NULL DEFAULT '', `OnWaitingList` bit(1) NOT NULL DEFAULT b'0', `AttendedEvent` bit(1) NOT NULL DEFAULT b'0', `Comments` varchar(255) DEFAULT NULL, `WebinarParticipant` bit(1) NOT NULL DEFAULT b'0', `AttendeePriceVerified` bit(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`,`Site_ID`,`User_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;");
			var dbCreateTableResults = dbCreateTable.execute();
		} else {
			// Database Table Exists, We must Drop it to create it again
			var dbDropTable = new query();
			dbDropTable.setDatasource("#application.configBean.getDatasource()#");
			dbDropTable.setSQL("DROP TABLE p_EventRegistration_UserRegistrations");
			var dbDropTableResults = dbDropTable.execute();

			if (len(dbDropTableResults.getResult()) eq 0) {
				var dbCreateTable = new query();
				dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTable.setSQL("CREATE TABLE `p_EventRegistration_UserRegistrations` ( `TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `RegistrationID` varchar(35) NOT NULL DEFAULT '', `RegistrationDate` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `User_ID` char(35) NOT NULL, `EventID` int(10) NOT NULL DEFAULT '0', `RequestsMeal` bit(1) NOT NULL DEFAULT b'0', `IVCParticipant` bit(1) NOT NULL DEFAULT b'0', `AttendeePrice` double(6,2) DEFAULT '0.00', `RegistrationIPAddr` varchar(15) NOT NULL DEFAULT '0.0.0.0', `RegisterByUserID` varchar(35) NOT NULL DEFAULT '', `OnWaitingList` bit(1) NOT NULL DEFAULT b'0', `AttendedEvent` bit(1) NOT NULL DEFAULT b'0', `Comments` varchar(255) DEFAULT NULL, `WebinarParticipant` bit(1) NOT NULL DEFAULT b'0', `AttendeePriceVerified` bit(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`,`Site_ID`,`User_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;");
				var dbCreateTableResults = dbCreateTable.execute();
			} else {

				 writedump(dbDropTableResults.getResult());
				 abort;
			}
		}

		var dbCheckTables = new query();
		dbCheckTables.setDatasource("#application.configBean.getDatasource()#");
		dbCheckTables.setSQL("Show Tables LIKE 'p_EventRegistration_Events'");
		var dbCheckTablesResults = dbCheckTables.execute();

		if (dbCheckTablesResults.getResult().recordcount eq 0) {
			// Since the Database Table does not exists, Lets Create it
			var dbCreateTable = new query();
			dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
			dbCreateTable.setSQL("CREATE TABLE `p_EventRegistration_Events` ( `TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `ShortTitle` tinytext NOT NULL, `EventDate` date NOT NULL DEFAULT '1980-01-01', `EventDate1` date DEFAULT NULL, `EventDate2` date DEFAULT NULL, `EventDate3` date DEFAULT NULL, `EventDate4` date DEFAULT NULL, `EventDate5` date DEFAULT NULL, `LongDescription` longtext, `Event_StartTime` time DEFAULT NULL, `Event_EndTime` time DEFAULT NULL, `Registration_Deadline` date NOT NULL DEFAULT '1980-01-01', `Registration_BeginTime` time DEFAULT NULL, `Registration_EndTime` time DEFAULT NULL, `EventFeatured` bit(1) NOT NULL DEFAULT b'0', `Featured_StartDate` date DEFAULT '1980-01-01', `Featured_EndDate` date DEFAULT '1980-01-01', `Featured_SortOrder` int(10) DEFAULT '100', `MemberCost` decimal(6,2) DEFAULT NULL, `NonMemberCost` decimal(6,2) DEFAULT NULL, `EarlyBird_RegistrationDeadline` date DEFAULT '1980-01-01', `EarlyBird_RegistrationAvailable` bit(1) NOT NULL DEFAULT b'0', `EarlyBird_MemberCost` decimal(6,2) DEFAULT NULL, `EarlyBird_NonMemberCost` decimal(6,2) DEFAULT NULL, `ViewSpecialPricing` bit(1) NOT NULL DEFAULT b'0', `SpecialMemberCost` decimal(6,2) DEFAULT NULL, `SpecialNonMemberCost` decimal(6,2) DEFAULT NULL, `SpecialPriceRequirements` longtext, `PGPAvailable` bit(1) NOT NULL DEFAULT b'0', `PGPPoints` decimal(5,2) DEFAULT NULL, `MealProvided` bit(1) NOT NULL DEFAULT b'0', `MealProvidedBy` int(11) DEFAULT NULL, `MealCost_Estimated` decimal(6,2) DEFAULT '0.00', `AllowVideoConference` bit(1) NOT NULL DEFAULT b'0', `VideoConferenceInfo` longtext, `VideoConferenceCost` decimal(6,2) DEFAULT NULL, `AcceptRegistrations` bit(1) NOT NULL DEFAULT b'0', `EventAgenda` longtext, `EventTargetAudience` longtext, `EventStrategies` longtext, `EventSpecialInstructions` longtext, `MaxParticipants` int(10) DEFAULT '0', `LocationType` char(1) NOT NULL DEFAULT 'S', `LocationID` int(10) DEFAULT '0', `LocationRoomID` int(10) DEFAULT '0', `Presenters` tinytext, `Facilitator` char(35) DEFAULT '0', `dateCreated` date NOT NULL, `lastUpdated` date DEFAULT NULL, `lastUpdateBy` char(35) DEFAULT NULL, `Active` bit(1) NOT NULL DEFAULT b'0', `EventCancelled` bit(1) NOT NULL DEFAULT b'0', `WebinarAvailable` bit(1) NOT NULL DEFAULT b'0', `WebinarConnectInfo` mediumtext, `WebinarMemberCost` decimal(6,2) DEFAULT NULL, `WebinarNonMemberCost` decimal(6,2) DEFAULT NULL, `PostedTo_Facebook` bit(1) NOT NULL DEFAULT b'0', `PostedTo_Twitter` bit(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`,`Site_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;");
			var dbCreateTableResults = dbCreateTable.execute();
		} else {
			// Database Table Exists, We must Drop it to create it again
			var dbDropTable = new query();
			dbDropTable.setDatasource("#application.configBean.getDatasource()#");
			dbDropTable.setSQL("DROP TABLE p_EventRegistration_Events");
			var dbDropTableResults = dbDropTable.execute();

			if (len(dbDropTableResults.getResult()) eq 0) {
				var dbCreateTable = new query();
				dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTable.setSQL("CREATE TABLE `p_EventRegistration_Events` ( `TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `ShortTitle` tinytext NOT NULL, `EventDate` date NOT NULL DEFAULT '1980-01-01', `EventDate1` date DEFAULT NULL, `EventDate2` date DEFAULT NULL, `EventDate3` date DEFAULT NULL, `EventDate4` date DEFAULT NULL, `EventDate5` date DEFAULT NULL, `LongDescription` longtext, `Event_StartTime` time DEFAULT NULL, `Event_EndTime` time DEFAULT NULL, `Registration_Deadline` date NOT NULL DEFAULT '1980-01-01', `Registration_BeginTime` time DEFAULT NULL, `Registration_EndTime` time DEFAULT NULL, `EventFeatured` bit(1) NOT NULL DEFAULT b'0', `Featured_StartDate` date DEFAULT '1980-01-01', `Featured_EndDate` date DEFAULT '1980-01-01', `Featured_SortOrder` int(10) DEFAULT '100', `MemberCost` decimal(6,2) DEFAULT NULL, `NonMemberCost` decimal(6,2) DEFAULT NULL, `EarlyBird_RegistrationDeadline` date DEFAULT '1980-01-01', `EarlyBird_RegistrationAvailable` bit(1) NOT NULL DEFAULT b'0', `EarlyBird_MemberCost` decimal(6,2) DEFAULT NULL, `EarlyBird_NonMemberCost` decimal(6,2) DEFAULT NULL, `ViewSpecialPricing` bit(1) NOT NULL DEFAULT b'0', `SpecialMemberCost` decimal(6,2) DEFAULT NULL, `SpecialNonMemberCost` decimal(6,2) DEFAULT NULL, `SpecialPriceRequirements` longtext, `PGPAvailable` bit(1) NOT NULL DEFAULT b'0', `PGPPoints` decimal(5,2) DEFAULT NULL, `MealProvided` bit(1) NOT NULL DEFAULT b'0', `MealProvidedBy` int(11) DEFAULT NULL, `MealCost_Estimated` decimal(6,2) DEFAULT '0.00', `AllowVideoConference` bit(1) NOT NULL DEFAULT b'0', `VideoConferenceInfo` longtext, `VideoConferenceCost` decimal(6,2) DEFAULT NULL, `AcceptRegistrations` bit(1) NOT NULL DEFAULT b'0', `EventAgenda` longtext, `EventTargetAudience` longtext, `EventStrategies` longtext, `EventSpecialInstructions` longtext, `MaxParticipants` int(10) DEFAULT '0', `LocationType` char(1) NOT NULL DEFAULT 'S', `LocationID` int(10) DEFAULT '0', `LocationRoomID` int(10) DEFAULT '0', `Presenters` tinytext, `Facilitator` char(35) DEFAULT '0', `dateCreated` date NOT NULL, `lastUpdated` date DEFAULT NULL, `lastUpdateBy` char(35) DEFAULT NULL, `Active` bit(1) NOT NULL DEFAULT b'0', `EventCancelled` bit(1) NOT NULL DEFAULT b'0', `WebinarAvailable` bit(1) NOT NULL DEFAULT b'0', `WebinarConnectInfo` mediumtext, `WebinarMemberCost` decimal(6,2) DEFAULT NULL, `WebinarNonMemberCost` decimal(6,2) DEFAULT NULL, `PostedTo_Facebook` bit(1) NOT NULL DEFAULT b'0', `PostedTo_Twitter` bit(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`,`Site_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;");
				var dbCreateTableResults = dbCreateTable.execute();
			} else {

				 writedump(dbDropTableResults.getResult());
				 abort;
			}
		}



		var NewGroupEventFacilitator = #application.userManager.read("")#;
		NewGroupEventFacilitator.setSiteID(Session.SiteID);
		NewGroupEventFacilitator.setGroupName("Event Facilitator");
		NewGroupEventFacilitator.setType(1);
		NewGroupEventFacilitator.setIsPublic(1);
		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupAuctionAdmin)#;

		var NewGroupEventPresentator = #application.userManager.read("")#;
		NewGroupEventPresentator.setSiteID(Session.SiteID);
		NewGroupEventPresentator.setGroupName("Event Presentator");
		NewGroupEventPresentator.setType(1);
		NewGroupEventPresentator.setIsPublic(1);
		NewGroupEventPresentatorStatus = #Application.userManager.create(NewGroupAuctionAdmin)#;
	}

	public void function update() {
		// triggered by the pluginManager when the plugin is UPDATED.
		application.appInitialized = false;
	}

	public void function delete() {
		// triggered by the pluginManager when the plugin is DELETED.
		application.appInitialized = false;

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE p_EventRegistration_Membership");
		var dbDropTableResults = dbDropTable.execute();

		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE p_EventRegistration_UserMatrix");
		var dbDropTableResults = dbDropTable.execute();

		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE p_EventRegistration_UserRegistrations");
		var dbDropTableResults = dbDropTable.execute();

		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE p_EventRegistration_Events");
		var dbDropTableResults = dbDropTable.execute();

		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}
	}

}