using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace Filemanager.Classes
{
    public class FileItem
    {
        private string _address;

        public FileItem(string address)
        {
            _address = address;
        }

        public string Address
        {
            get { return _address.Replace(HttpContext.Current.Server.MapPath("/"), "").Replace("\\", "/"); }
            set { _address = value; }
        }

        public string Extension
        {
            get
            {
                try
                {
                    return Path.GetExtension(Address);
                }
                catch (Exception)
                {
                    return "";
                }
            }
        }

        public string Category { get { return GetCategory(Extension); } }

        protected string GetCategory(string extension)
        {
            string[] imageTypes = { ".jpg", ".jpeg", ".png", ".bmp", ".tiff", ".gif" };
            string[] programTypes = { ".html", ".cs", ".js", ".css", ".aspx", ".ashx", ".config" };
            if (Extension.Equals("folder", StringComparison.InvariantCultureIgnoreCase))
            {
                return "Folder";
            }
            else if (imageTypes.Contains(extension.ToLower()))
            {
                return "Image";
            }
            else if (programTypes.Contains(extension.ToLowerInvariant()))
            {
                return "Code";
            }
            return "Unknown";
        }
    }
}