## Power BI Premium Embedded with adhoc workspace sample.
Steps

1. Need to install NuGet packages 
```
Install-Package Microsoft.PowerBI.Api
Install-Package Microsoft.IdentityModel.Clients.ActiveDirectory
Install-Package Newtonsoft.Json -Version 11.0.1
```
2. PBI Embed required app registration. Register the app in Azure AD with master account and proper permissions
https://docs.microsoft.com/en-us/power-bi/developer/embed-sample-for-customers

3. Create a file private file to store credentials information as below and reference it from web.config for the below app setting. In Azure you can add them as app settings so you only need the private file for local testing.
```
<!--do not store credentials in cleartext outside for testing -->
<appSettings>
	<add key="authorityUrl" value="https://login.windows.net/common/oauth2/authorize/" />
	<add key="resourceUrl" value="https://analysis.windows.net/powerbi/api" />
	<add key="apiUrl" value="https://api.powerbi.com/" />
	<add key="embedUrlBase" value="https://app.powerbi.com/" />
	<add key="appWorkspaceId" value="" />
	<add key="applicationId" value="" />
	<add key="pbiUsername" value="" />
	<add key="pbiPassword" value="" />
</appSettings>
```
4. You can use the following Power BI desktop file as a sample in the PBI Embed workspace
https://github.com/Microsoft/powerbi-desktop-samples

5. This sample uses PBI row level security for demo purpose. Please remove for other use cases. If you need to setup RLS please refer to the following documentation. https://docs.microsoft.com/en-us/power-bi/service-admin-rls. Or setup using Analysis Service.
