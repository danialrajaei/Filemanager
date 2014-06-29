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
                var opName = context.Request.QueryString["opName"];
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
                    default:
                        break;
                }
                context.Response.Write(JsonConvert.SerializeObject(retList));
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