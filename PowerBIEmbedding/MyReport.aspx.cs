using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Configuration;
using Microsoft.IdentityModel.Clients.ActiveDirectory;
using Microsoft.Rest;
using Microsoft.PowerBI.Api.V2;
using Microsoft.PowerBI.Api.V2.Models;

namespace PowerBIEmbedding
{
    public partial class MyReport : System.Web.UI.Page
    {
        private static readonly string AuthorityUrl = ConfigurationManager.AppSettings["authorityUrl"];

        private static readonly string ResourceUrl = ConfigurationManager.AppSettings["resourceUrl"];
        private static readonly string ApiUrl = ConfigurationManager.AppSettings["apiUrl"];
        private static readonly string AppWorkspaceId = ConfigurationManager.AppSettings["appUserWorkspaceId"];
        private static readonly string ApplicationId = ConfigurationManager.AppSettings["applicationId"];
        private static readonly string UserReportTemplateId = ConfigurationManager.AppSettings["UserReportTemplateId"];
        private static readonly string UserDatasetTemplateId = ConfigurationManager.AppSettings["UserDatasetTemplateId"];

        private static readonly string Username = ConfigurationManager.AppSettings["pbiUsername"];
        private static readonly string Password = ConfigurationManager.AppSettings["pbiPassword"];

        public string embedToken;
        public string embedUrl;
        public string reportId;
        public string mgrName;
        public bool UserHasExistingReportInWorkspace;

        protected void Page_Load(object sender, EventArgs e)
        {
            var credential = new UserPasswordCredential(Username, Password);

            // Authenticate using app settings credentials
            var authenticationContext = new AuthenticationContext(AuthorityUrl);
            var authenticationResult = authenticationContext.AcquireTokenAsync(ResourceUrl, ApplicationId, credential).Result;

            var tokenCredentials = new TokenCredentials(authenticationResult.AccessToken, "Bearer");

            if (this.Page.PreviousPage != null)
            {
                DropDownList mgrDropList = (DropDownList)this.Page.PreviousPage.FindControl("ddlManager");
                mgrName = mgrDropList.SelectedValue;
                reportId = UserReportTemplateId;

            }

            if (!IsPostBack)
            {
                var reportName = "US_Sales_User_Adhoc_" + mgrName.Replace(" ", "_");


                using (var client = new PowerBIClient(new Uri(ApiUrl), tokenCredentials))
                {
                    // Get a list of reports
                    var reports = client.Reports.GetReportsInGroup(AppWorkspaceId);

                    // Populate dropdown list
                    foreach (Report item in reports.Value)
                    {
                        if (item.Name == reportName)
                        {
                            UserHasExistingReportInWorkspace = true;
                            reportId = item.Id;
                        }

                    }
                }


                using (var client = new PowerBIClient(new Uri(ApiUrl), tokenCredentials))
                {
                    var report = client.Reports.GetReportInGroup(AppWorkspaceId, reportId); ;

                    if (!UserHasExistingReportInWorkspace)
                    {
                        var cloneReportRequest = new CloneReportRequest(reportName, AppWorkspaceId, UserDatasetTemplateId);
                        report = client.Reports.CloneReport(AppWorkspaceId, UserReportTemplateId, cloneReportRequest);
                    }

                    //var report = client.Reports.CloneReportInGroup(AppWorkspaceId, UserReportTemplateId, cloneReportRequest);


                    // Generate an embed token to view
                    // Generate an embed token to view
                    var generateTokenRequestParameters =
                        new GenerateTokenRequest("edit", identities: new List<EffectiveIdentity> {
                    new EffectiveIdentity(
                            username: mgrName.Replace(' ', '~'),
                            roles: new List<string> { "Manager" },
                            datasets: new List<string> { report.DatasetId })
                        });
                    var tokenResponse = client.Reports.GenerateTokenInGroup(AppWorkspaceId, report.Id, generateTokenRequestParameters);

                    // Populate embed variables (to be passed client-side)
                    embedToken = tokenResponse.Token;
                    embedUrl = report.EmbedUrl;
                    reportId = report.Id;

                }
            }
        }
        protected void StandardReport_Click(Object sender, EventArgs e)
        {
          Server.Transfer("~/EmbedReport.aspx");
          
        }

       
    }
}