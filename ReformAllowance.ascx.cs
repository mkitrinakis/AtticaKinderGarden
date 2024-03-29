using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Microsoft.SharePoint;


namespace Custom
{

    

    public partial class ReformAllowance : System.Web.UI.UserControl
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
                dispStatus.Text = itm.ID > 0 ? (itm["OldStatus"] ?? "").ToString() : "Πρόχειρο" ;
                
                //requestText.Text = "Ðáñáêáëþ íá ìïõ åãêñßíåôå ôçí êáôáâïëÞ ôïõ ðïóïý ôï ïðïßï ìïõ áíáëïãåß, âÜóåé ôçò Åãêõêëßïõ 4629/16/08.09.2022 ôçò ÔñÜðåæáò ãéá ôç öéëïîåíßá ôïõ ðáéäéïý ìïõ óôïí Âñåöïíçðéáêü/Ðáéäéêü Óôáèìü Þ Íçðéáãùãåßï "; 
            }
            catch (Exception e)
            {
                requestorCode.Text = e.Message; 
            }
            
        }



        private string createScript(string cUrl, string sourceUrl, string destUrl, string msg, bool toRoot )
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