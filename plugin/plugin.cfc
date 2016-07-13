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
	}

}