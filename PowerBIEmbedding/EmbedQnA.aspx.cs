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
    public partial class EmbedQnA : System.Web.UI.Page
    {
        private static readonly string AuthorityUrl = ConfigurationManager.AppSettings["authorityUrl"];

        private static readonly string ResourceUrl = ConfigurationManager.AppSettings["resourceUrl"];
        private static readonly string ApiUrl = ConfigurationManager.AppSettings["apiUrl"];
        private static readonly string AppWorkspaceId = ConfigurationManager.AppSettings["appWorkspaceId"];
        private static readonly string ApplicationId = ConfigurationManager.AppSettings["applicationId"];

        private static readonly string Username = ConfigurationManager.AppSettings["pbiUsername"];
        private static readonly string Password = ConfigurationManager.AppSettings["pbiPassword"];

        public string embedToken;
        public string embedUrl;
        public string datasetId;

        protected void Page_Load(object sender, EventArgs e)
        {
            var credential = new UserPasswordCredential(Username, Password);

            // Authenticate using app settings credentials
            var authenticationContext = new AuthenticationContext(AuthorityUrl);
            var authenticationResult = authenticationContext.AcquireTokenAsync(ResourceUrl, ApplicationId, credential).Result;

            var tokenCredentials = new TokenCredentials(authenticationResult.AccessToken, "Bearer");

            if (!IsPostBack)
            {
                using (var client = new PowerBIClient(new Uri(ApiUrl), tokenCredentials))
                {
                    // Get a list of qnas
                    var datasets = client.Datasets.GetDatasetsInGroup(AppWorkspaceId);

                    // Populate dropdown list
                    foreach (Dataset item in datasets.Value)
                    {
                        ddlDataset.Items.Add(new ListItem(item.Name, item.Id));
                    }

                    // Select first item
                    ddlDataset.SelectedIndex = 0;
                }
            }

            // Generate an embed token and populate embed variables
            using (var client = new PowerBIClient(new Uri(ApiUrl), tokenCredentials))
            {
                // Retrieve the selected dataset
                var dataset = client.Datasets.GetDatasetByIdInGroup(AppWorkspaceId, ddlDataset.SelectedValue);

                // Generate an embed token to view
                var generateTokenRequestParameters = new GenerateTokenRequest(accessLevel: "view");
                var tokenResponse = client.Datasets.GenerateTokenInGroup(AppWorkspaceId, dataset.Id, generateTokenRequestParameters);

                // Populate embed variables (to be passed client-side)
                embedToken = tokenResponse.Token;
                embedUrl = "https://app.powerbi.com/qnaEmbed?groupId=" + AppWorkspaceId;
                datasetId = dataset.Id;
            }
        }
    }
}