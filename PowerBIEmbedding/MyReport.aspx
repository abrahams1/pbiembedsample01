<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="MyReport.aspx.cs" Inherits="PowerBIEmbedding.MyReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <script src="/scripts/powerbi.js"></script>
    <form id="form1" runat="server">
        <table class="imagetable">
        <tr>
	        <th>
                
	        </th>
            <th>
               <asp:Button id="backButton" Text="<- Standard Reports" OnClick="Back_Click" runat="server"/>
            </th>
            <th>
                <asp:Button id="saveButton" Text="Save My Reports" OnClick="SaveMyReports_Click" runat="server"/>
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
