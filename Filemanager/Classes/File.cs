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

        private FileInfo fileInfo;

        public string Title { get { return Address.ToCharArray().Contains('/') ? Address.Remove(0, Address.LastIndexOf('/')).TrimStart('/') : Address; } }

        public FileItem(string address)
        {
            _address = address;
            fileInfo = new FileInfo(_address);
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
                    var ext = Path.GetExtension(Address);
                    return string.IsNullOrEmpty(ext) ? "folder" : ext.TrimStart('.');
                }
                catch (Exception)
                {
                    return "";
                }
            }
        }

        public string Category { get { return GetCategory(Extension); } }

        public long FileSize { get { return Category.ToLower() == "folder" ? 0 : fileInfo.Length; } }

        public DateTime DateCreated { get { return fileInfo.CreationTime; } }

        protected string GetCategory(string extension)
        {
            string[] imageTypes = { ".jpg", ".jpeg", ".png", ".bmp", ".tiff", ".gif" };
            string[] programTypes = { ".html", ".cs", ".js", ".css", ".aspx", ".ashx", ".config" };
            if (Extension.Equals("folder", StringComparison.InvariantCultureIgnoreCase) || string.IsNullOrEmpty(Extension))
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