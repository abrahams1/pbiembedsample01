<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmbedReport.aspx.cs" Inherits="PowerBIEmbedding.EmbedReport" %>

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
	        <th><span>Report: </span> 
                <asp:DropDownList ID="ddlReport" runat="server" AutoPostBack="True" OnSelectedIndexChanged="Page_Load" />
	        </th>
            <th>
                <span>View as Manager: </span>
                <asp:DropDownList ID="ddlManager" runat="server" AutoPostBack="True" OnSelectedIndexChanged="Page_Load">
	                <asp:ListItem Text="Ananya Kumar" />
	                <asp:ListItem Text="Carmen Carrington" />
	                <asp:ListItem Text="Haruto Suzuki" />
	                <asp:ListItem Text="Jane Campbell" />
	                <asp:ListItem Text="John Bishop" />
	                <asp:ListItem Text="Ted Baker" />
	                <asp:ListItem Text="Ty Johnston" />
                </asp:DropDownList>

            </th>
            <th>
                <asp:Button id="ddlButton" Text="My Reports" OnClick="MyReports_Click" runat="server"/>
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
                    navContentPaneEnabled: true,
                    extensions: [
                        {
                            command: {
                                name: "cmdShowValue",
                                title: "Show Value in MessageBox",
                                extend: {
                                    visualContextMenu: {
                                        title: "Show Value in MessageBox"
                                    }
                                }
                            }
                        }
                    ]
                }
            };

            // Embed the report within the div element
            var report = powerbi.embed(embedDiv, config);

            // Add an event handler for the commandTriggered event
            report.on("commandTriggered", function (command) {
                // Determine the command detail
                var commandDetails = command.detail;

                // If they command is cmdShowValue, show a message box
                if (commandDetails.command == "cmdShowValue") {
                    // Retrieve specific details from the selected data point
                    var category = commandDetails.dataPoints[0].identity[0].equals;
                    var value = commandDetails.dataPoints[0].values[0].formattedValue;

                    // Open message box
                    alert(category + " value is " + value);
                }
            });

        </script>

    </form>
</body>
</html>
