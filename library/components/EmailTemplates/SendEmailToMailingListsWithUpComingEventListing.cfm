<cfmail To="#getUserAccount.FName# #getUserAccount.LName# <#getUserAccount.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Event Registration: UpComming Events" server="127.0.0.1">
<cfmailparam file="#Session.EmailMarketing.WebExportCompletedFile#" type="application/pdf">
<cfmailpart type="text/plain">
#getUserAccount.FName# #getUserAccount.LName#,

Mailing List Email

Note: This is an automated email address and not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# #rc.$.siteConfig('ContactEmail')# #rc.$.siteConfig('ContactPhone')#
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getUserAccount.FName# #getUserAccount.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Mailing List Email</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: This is an automated email address and not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# #rc.$.siteConfig('ContactEmail')# #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>