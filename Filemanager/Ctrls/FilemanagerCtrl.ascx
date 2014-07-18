<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FilemanagerCtrl.ascx.cs" Inherits="Filemanager.Ctrls.FilemanagerCtrl" %>
<link href="../Content/filemanager/icon.css" rel="stylesheet" />
<table class="col-xs-12 col-sm-12 col-md-12 col-lg-12 fm-table">
    <tr class="fm-topmenu">
        <td class="fm-menu" colspan="2">
            <div class="col-xs-offset-6 col-sm-offset-6 col-md-offset-4 col-lg-offset-4">
                <div class="btn-toolbar">
                    <div class="btn-group">
                        <button type="button" class="btn btn-default" id="fm-btn-upload" data-toggle="tooltip" data-translate-title="uploadTitle" data-placement="bottom">
                            <div class="icon icon-upload"></div>
                        </button>
                        <button type="button" class="btn btn-default" id="fm-btn-newfolder" data-toggle="tooltip" data-translate-title="addFolderTitle" data-placement="bottom">
                            <div class="icon icon-addFolder"></div>
                        </button>
                        <button type="button" class="btn btn-default" id="fm-btn-newfile" data-toggle="tooltip" data-translate-title="addFileTitle" data-placement="bottom">
                            <div class="icon icon-addFile"></div>
                        </button>
                    </div>
                    <div class="btn-group fm-btngroup-open">
                        <button type="button" class="btn btn-default" id="fm-btn-openFile" data-toggle="tooltip" data-translate-title="viewTitle" data-placement="bottom">
                            <div class="icon icon-view"></div>
                        </button>
                        <button type="button" class="btn btn-default" id="fm-btn-download" data-toggle="tooltip" data-translate-title="downloadTitle" data-placement="bottom">
                            <div class="icon icon-download"></div>
                        </button>
                    </div>
                    <div class="btn-group fm-btngroup-edit">
                        <button type="button" class="btn btn-default" id="fm-btn-copy" data-toggle="tooltip" data-translate-title="copyTitle" data-placement="bottom" value="Copy">
                            <div class="icon icon-copy"></div>
                        </button>
                        <button type="button" class="btn btn-default" id="fm-btn-cut" data-toggle="tooltip" data-translate-title="cutTitle" data-placement="bottom" value="Cut">
                            <div class="icon icon-cut"></div>
                        </button>
                        <button type="button" class="btn btn-default" id="fm-btn-paste" data-toggle="tooltip" data-translate-title="pasteTitle" data-placement="bottom" value="Paste">
                            <div class="icon icon-paste"></div>
                        </button>
                        <button type="button" class="btn btn-default" id="fm-btn-duplicate" data-toggle="tooltip" data-translate-title="duplicateTitle" data-placement="bottom" value="duplicate">
                            <div class="icon icon-duplicate"></div>
                        </button>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-default" id="fm-btn-delete" data-toggle="tooltip" data-translate-title="deleteTitle" data-placement="bottom" value="Delete">
                            <div class="icon icon-delete"></div>
                        </button>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn btn-default" id="fm-btn-rename" data-toggle="tooltip" data-translate-title="renameTitle" data-placement="bottom" value="Rename">
                            <div class="icon icon-rename"></div>
                        </button>
                    </div>
                    <div class="input-group input-group-sm pull-right">
                        <input type="text" class="form-control" id="txtSearch">
                        <span class="input-group-btn">
                            <button class="btn btn-default" type="button" id="btnSearch"><span class="glyphicon glyphicon-search"></span>&nbsp</button>
                        </span>
                    </div>
                </div>
            </div>
        </td>
    </tr>
    <tr>
        <td class="col-xs-6 col-sm-6 col-md-3 col-lg-3 fm-left">
            <ul class="fm-tree-directory">
                <li class="fm-dirname" data-value="<%= this.RootPath %>"><span class="fm-toggle-subtree"></span>
                    <label class="fm-dirname" data-translate-text="root"></label>
                </li>
            </ul>
        </td>
        <td class="col-xs-6 col-sm-6 col-md-9 col-lg-9 fm-right">
            <ul class="fm-files"></ul>
        </td>
    </tr>
    <tr class="fm-statusbar">
        <td class="fm-attributes" colspan="2">
            <table class="fm-statusbar-content">
                <tr>
                    <td data-translate-text="fullAddress"></td>
                    <td>"<span class="fm-attr-address"></span>"</td>
                    <td style="padding-left: 20px;" data-translate-text="size"></td>
                    <td>"<span class="fm-attr-size"></span>"</td>
                    <td style="padding-left: 20px;" data-translate-text="creationDateTime"></td>
                    <td>"<span class="fm-attr-creationDate"></span>"</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<div class="modal fade" id="uploadModal">
    <div class="modal-dialog">
        <div class="modal-content">
            </form>
            <form name="uploadFrm" action="/FilemanagerHandler.ashx" method="POST" enctype="multipart/form-data">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only" data-translate-text="close"></span></button>
                    <h4 class="modal-title" data-translate-text="uploadFile"></h4>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="opName" value="uplaodFile" />
                    <input type="hidden" name="dir" value='<%= this.RootPath %>' />
                    <p>
                        <input type="file" name="fileUpload" multiple="multiple" />
                    </p>
                </div>
                <div class="modal-footer">
                    <input type="submit" data-translate-value="submit" />
                </div>
                <div class="progress hide">
                    <div class="progress-bar progress-bar-info progress-bar-striped active" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0;">
                    </div>
                </div>
            </form>
            <form>
        </div>
    </div>
</div>
<div class="modal fade" id="newFolderModal">
    <div class="modal-dialog">
        <div class="modal-content">
            </form>
            <form name="newFolderFrm" action="/FilemanagerHandler.ashx" method="POST" enctype="multipart/form-data">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only" data-translate-text="close"></span></button>
                    <h4 class="modal-title" data-translate-text="addNewFolder"></h4>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="opName" value="addFolder" />
                    <input type="hidden" name="dir" value='<%= this.RootPath %>' />
                    <p data-translate-text="promptFolderName"></p>
                    <p>
                        <input type="text" name="folderName" class="form-control" />
                    </p>
                </div>
                <div class="modal-footer">
                    <input type="submit" data-translate-value="submit" />
                </div>
            </form>
            <form>
        </div>
    </div>
</div>
<div class="modal fade" id="newFileModal">
    <div class="modal-dialog">
        <div class="modal-content">
            </form>
            <form name="newFileFrm" action="/FilemanagerHandler.ashx" method="POST" enctype="multipart/form-data">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only" data-translate-text="close"></span></button>
                    <h4 class="modal-title" data-translate-text="addNewFile"></h4>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="opName" value="addFile" />
                    <input type="hidden" name="dir" value='<%= this.RootPath %>' />
                    <p data-translate-text="promptFileName"></p>
                    <p>
                        <input type="text" name="fileName" class="form-control" />
                    </p>
                </div>
                <div class="modal-footer">
                    <input type="submit" data-translate-value="submit" />
                </div>
            </form>
            <form>
        </div>
    </div>
</div>
