using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IO;
using Filemanager.Classes;
using Newtonsoft.Json;

namespace Filemanager
{
    /// <summary>
    /// Summary description for FilemanagerHandler
    /// </summary>
    public class FilemanagerHandler : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            try
            {
                var opName = context.Request.Params["opName"];
                List<FileItem> retList = new List<FileItem>();
                switch (opName)
                {
                    case "getDirs":
                        var dir = context.Request.QueryString["dir"];
                        foreach (var address in Directory.GetDirectories(context.Server.MapPath(dir)))
                        {
                            retList.Add(new FileItem(address));
                        }
                        break;
                    case "getFiles":
                        dir = context.Request.QueryString["dir"];
                        foreach (var address in Directory.GetFiles(context.Server.MapPath(dir)))
                        {
                            retList.Add(new FileItem(address));
                        }
                        break;
                    case "uplaodFile":
                        dir = context.Request.Params["dir"];
                        HttpPostedFile file = context.Request.Files["fileUpload"];
                        if (file != null && file.ContentLength > 0)
                        {
                            string fileName = Path.GetFileName(file.FileName);
                            string address = context.Server.MapPath(Path.Combine(dir, fileName));
                            short i = 1;
                            while (File.Exists(address))
                            {
                                address = context.Server.MapPath(Path.Combine(dir, Path.GetFileNameWithoutExtension(fileName) + " (" + i + ")" + Path.GetExtension(fileName)));
                            }
                            file.SaveAs(address);
                        }
                        break;
                    case "addFolder":
                        dir = context.Request.Params["dir"];
                        Directory.CreateDirectory(context.Server.MapPath(Path.Combine(dir, context.Request.Params["folderName"].ToString())));
                        context.Response.Redirect(context.Request.UrlReferrer.ToString());
                        break;
                    case "addFile":
                        dir = context.Request.Params["dir"];
                        var filename =context.Request.Params["fileName"].ToString();
                        filename = string.IsNullOrEmpty(Path.GetExtension(filename))? filename+".txt": filename;
                        File.CreateText(context.Server.MapPath(Path.Combine(dir, filename)));
                        break;
                    case "dlFile":
                        dir = context.Request.Params["dir"];
                        context.Response.ContentType = "application/octet-stream";
                        filename = context.Server.MapPath(dir);
                        context.Response.WriteFile(filename);
                        context.Response.Headers.Add("Content-Disposition", "attachment;filename=" + Path.GetFileName(filename));
                        return;
                        break;
                    default:
                        break;
                }
                if (context.Request.Headers["X-Requested-With"] == "XMLHttpRequest")
                    context.Response.Write(JsonConvert.SerializeObject(retList));
                else
                    context.Response.Redirect(context.Request.UrlReferrer.ToString());
            }
            catch (Exception)
            {

            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}