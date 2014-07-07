using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;

namespace Filemanager.Ctrls
{
    public partial class FilemanagerCtrl : System.Web.UI.UserControl
    {
        private string _rootPath = "/";
        public string RootPath
        {
            get { return _rootPath; }
            set { _rootPath = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            if (!string.IsNullOrEmpty(Request.QueryString["langCode"]))
            {
                var langCode = Request.QueryString["langCode"];
                if (File.Exists(Server.MapPath(Path.Combine("/Content/filemanager/Lang/", langCode + ".js"))))
                {
                    Page.ClientScript.RegisterClientScriptInclude(langCode, Path.Combine("/Content/filemanager/Lang/", langCode + ".js"));
                }
                else
                    Page.ClientScript.RegisterClientScriptInclude("En", "/Content/filemanager/Lang/En.js");
            }
            else
                    Page.ClientScript.RegisterClientScriptInclude("En", "/Content/filemanager/Lang/En.js");
        }
    }
}