## Filemanager

This filemanager has been written in ASP.net using C#.

**Installation and Setup**

Simply download the whole project and open Filemanager.sln in VS.

*Requied Files
- Classe\File.cs contains a class for files object.
- Filemanager\Content\filemanager has images and Lang folder for Internationalization (i18ln)
- Ctrls\FilemanagerCtrl.\* is the custom web controller that can be used in web pages
- Scripts\Filemanager.js is the beautify version of filemanager script

In web.config
add this tag in syste.web>HttpHandlers>
<add verb="GET" path="/FilemanagerHandler.ashx" type="Filemanager.FilemanagerHandler"/>

You can also change the root path of filemanager by changing the rootPath Property of FilemanagerCtrl control and select your prefered language by passing > langCode though GET example:
http:/localhost/filemanager.aspx?langCode=en