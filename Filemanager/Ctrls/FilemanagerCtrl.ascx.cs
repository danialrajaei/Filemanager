using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

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

        }
    }
}