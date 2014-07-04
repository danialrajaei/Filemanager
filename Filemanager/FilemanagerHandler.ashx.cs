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
                short i;
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
                            i = 1;
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
                    case "copy":
                        var dir1 = context.Request.Params["dir1"];
                        var dir2 = context.Request.Params["dir2"];
                        var addressTocopy = context.Server.MapPath(Path.Combine(dir1, Path.GetFileName(dir2)));
                        i = 1;
                            while (File.Exists(addressTocopy))
                            {
                                addressTocopy =
                                    context.Server.MapPath(Path.Combine(dir1,
                                                                        Path.GetFileNameWithoutExtension(dir2) + " (" +
                                                                        i + ")" + Path.GetExtension(dir2)));
                            }
                        File.Copy(context.Server.MapPath(dir2), addressTocopy);
                        break;
                    case "cut":
                        dir1 = context.Request.Params["dir1"];
                        dir2 = context.Request.Params["dir2"];
                        addressTocopy = context.Server.MapPath(Path.Combine(dir1, Path.GetFileName(dir2)));
                        i = 1;
                            while (File.Exists(addressTocopy))
                            {
                                addressTocopy =
                                    context.Server.MapPath(Path.Combine(dir1,
                                                                        Path.GetFileNameWithoutExtension(dir2) + " (" +
                                                                        i + ")" + Path.GetExtension(dir2)));
                            }
                        File.Move(context.Server.MapPath(dir2), addressTocopy);
                        break;
                    case "delete":
                        dir = context.Request.Params["dir"];
                        string deleteAdd = context.Server.MapPath(dir);
                        if (File.Exists(deleteAdd))
                        {
                            File.Delete(deleteAdd);
                        }
                        else
                        {
                            if (Directory.Exists(deleteAdd))
                                Directory.Delete(deleteAdd);
                        }
                        break;
                    case "rename":
                        dir = context.Server.MapPath(context.Request.Params["dir"]);
                        var rename = context.Request.Params["name"];
                        if (File.Exists(dir))
                        {
                            var renameAdd = string.IsNullOrEmpty(Path.GetExtension(rename))
                                                ? Path.Combine(Path.GetDirectoryName(dir),
                                                               rename + Path.GetExtension(dir))
                                                : Path.Combine(Path.GetDirectoryName(dir), rename);
                            File.Move(dir, renameAdd);
                            retList.Add(new FileItem(renameAdd));
                        }
                        else if (Directory.Exists(dir))
                        {
                            var renameAdd = Path.Combine(dir.Remove(dir.LastIndexOf('\\') + 1), rename);
                            Directory.Move(dir, renameAdd);
                            retList.Add(new FileItem(renameAdd));
                        }
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