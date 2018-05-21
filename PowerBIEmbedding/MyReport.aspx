<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyReport.aspx.cs" Inherits="PowerBIEmbedding.MyReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <link href="Report.css" rel="stylesheet" type="text/css" />
    <script src="/scripts/powerbi.js"></script>
    <form id="form1" runat="server">
        <table class="imagetable">
        <tr>
	        <th>
                <span> Manager Name: <% =this.mgrName %></span>
	        </th>
            <th>
               <asp:Button id="backButton" Text="<- Standard Reports" OnClick="StandardReport_Click" runat="server"/>
            </th>
            <th>
                ** If you build a report and need to view it later use File -> Save **
            </th>
        </tr>
        </table>
        <br />
        <br />

        <div id="embedDiv" style="height: 800px; width: 100%; max-width: 1500px;" />
        <script>
	        // Read embed token
	        var embedToken = "<% =this.embedToken %>";

	        // Read embed URL
	        var embedUrl = "<% = this.embedUrl %>";

	        // Read report Id
	        var reportId = "<% = this.reportId %>";

	        // Get models (models contains enums)
	        var models = window['powerbi-client'].models;

	        // Embed configuration is used to describe what and how to embed
	        // This object is used when calling powerbi.embed
	        // It can also includes settings and options such as filters
	        var config = {
		        type: 'report',
		        tokenType: models.TokenType.Embed,
		        accessToken: embedToken,
		        embedUrl: embedUrl,
                id: reportId,
                permissions: models.Permissions.All, /*gives permissions*/
                viewMode: models.ViewMode.Edit,
		        settings: {
			        filterPaneEnabled: true,
                    navContentPaneEnabled: true
		        }
	        };

            // Embed the report within the div element
            var report = powerbi.embed(embedDiv, config);
           
        </script>
    </form>
</body>
</html>
