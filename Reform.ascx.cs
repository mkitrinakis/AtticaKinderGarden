using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.SharePoint;


namespace Custom
{



    public partial class Reform : System.Web.UI.UserControl
    {
        SPListItem itm;
        SPWeb web;
        protected void Page_Load(object sender, EventArgs e)
        {


            run();

        }


        private void run()
        {
            try
            {
                itm = SPContext.Current.ListItem;
                web = SPContext.Current.Web;
                //  SPUser u = web.Users[Convert.ToInt32((itm["Author"] ?? "").ToString().Split(';')[0])];
                SPUser u = itm.ID > 0 ? web.SiteUsers.GetByID(Convert.ToInt32((itm["Author"] ?? "").ToString().Split(';')[0])) : web.CurrentUser;
                requestorName.Text = u.Name;
                requestorCode.Text = u.LoginName.Contains('\\') ? u.LoginName.Split('\\')[1] : u.LoginName;
                //requestorName.Text = (itm["Author"] ?? "").ToString().Split(';')[0];
                //requestorName.Text = u.LoginName.Split('\\')[1];
                //requestorCode.Text = u.Name;
                dispStatus.Text = itm.ID > 0 ? (itm["OldStatus"] ?? "").ToString() : "Πρόχειρο";
                checkSameApprover(); 
            //    error.Text = (itm["_x0031__x03bf__x03c2__x0020__x03"] ?? "").ToString() + "~" + web.CurrentUser.ID;
                //requestText.Text = "Ðáñáêáëþ íá ìïõ åãêñßíåôå ôçí êáôáâïëÞ ôïõ ðïóïý ôï ïðïßï ìïõ áíáëïãåß, âÜóåé ôçò Åãêõêëßïõ 4629/16/08.09.2022 ôçò ÔñÜðåæáò ãéá ôç öéëïîåíßá ôïõ ðáéäéïý ìïõ óôïí Âñåöïíçðéáêü/Ðáéäéêü Óôáèìü Þ Íçðéáãùãåßï "; 
            }
            catch (Exception e)
            {
                requestorCode.Text = e.Message;
            }

        }


        private void checkSameApprover()
        {
            string url = Page.Request.Url.ToString();
            if (url.ToUpper().Contains("EDITFORM.ASPX"))
            {
                string status = (itm["OldStatus"] ?? "").ToString();
                if (status.Equals("Εκκρεμεί 2η Έγκριση"))
                {
                    string firstApproverID = (itm["_x0031__x03bf__x03c2__x0020__x03"] ?? "").ToString().Split(';')[0];
                    string currentUserID = web.CurrentUser.ID.ToString();
                    if (currentUserID.Trim().Equals(firstApproverID.Trim()))
                    {
                        errorSameApprover.Text = "<font color=\"red\"> Η 2η έγκριση πρέπει να γίνει από διαφορετικό χρήστη από ότι η 1η </font>";
                    }
                    else
                    {
                        errorSameApprover.Text = firstApproverID + "#" + currentUserID;
                    }
                }
                else
                {
                    errorSameApprover.Text = status;
                }
            }
        }

        private string createScript(string cUrl, string sourceUrl, string destUrl, string msg, bool toRoot)
        {
            if (!toRoot)
            {
                destUrl = cUrl.Replace(sourceUrl, destUrl);
            }
            string rs = "<script>" + Environment.NewLine;
            rs += "alert('" + msg + "');" + Environment.NewLine;
            rs += "window.location.href='" + destUrl + "';" + Environment.NewLine;
            rs += "</script>" + Environment.NewLine;
            return rs;
        }
    }

}