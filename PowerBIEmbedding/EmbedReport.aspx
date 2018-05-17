<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="EmbedReport.aspx.cs" Inherits="PowerBIEmbedding.EmbedReport" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:DropDownList ID="ddlReport" runat="server" AutoPostBack="True" OnSelectedIndexChanged="Page_Load" />
        <div>
        </div>
    </form>
</body>
</html>
