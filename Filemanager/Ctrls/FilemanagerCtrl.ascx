<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FilemanagerCtrl.ascx.cs" Inherits="Filemanager.Ctrls.FilemanagerCtrl" %>
<table class="col-xs-12 col-sm-12 col-md-12 col-lg-12 fm-table">
    <tr>
        <td class="fm-menu" colspan="2">
            <table style="margin: auto;">
                <tr>
                    <td>
                        <div class="btn-group">
                            <button type="button" class="btn btn-default" id="fm-btn-upload" data-toggle="tooltip" title="Upload file" data-placement="bottom">
                                <span class="glyphicon glyphicon-upload"></span>
                            </button>
                            <button type="button" class="btn btn-default" id="fm-btn-newfolder" data-toggle="tooltip" title="Add new folder" data-placement="bottom">
                                <span class="glyphicon glyphicon-folder-open"></span>
                            </button>
                            <button type="button" class="btn btn-default" id="fm-btn-newfile" data-toggle="tooltip" title="Add new file" data-placement="bottom">
                                <span class="glyphicon glyphicon-file"></span>
                            </button>
                        </div>
                        <div class="btn-group">
                            <button type="button" class="btn btn-default" id="fm-btn-openFile" data-toggle="tooltip" title="open in new tab" data-placement="bottom">
                                <span class="glyphicon glyphicon-folder-open"></span>
                            </button>
                            <button type="button" class="btn btn-default" id="fm-btn-download" data-toggle="tooltip" title="download" data-placement="bottom">
                                <span class="glyphicon glyphicon-file"></span>
                            </button>
                        </div>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class="col-xs-12 col-sm-12 col-md-3 col-lg-3 fm-left">
            <ul class="fm-tree-directory">
                <li class="fm-dirname" data-value="<%= this.RootPath %>"><span class="fm-toggle-subtree">-</span><label class="fm-dirname">Root</label></li>
            </ul>
        </td>
        <td class="col-xs-12 col-sm-12 col-md-9 col-lg-9 fm-right">
            <ul class="fm-files"></ul>
        </td>
    </tr>
    <tr>
        <td class="fm-attributes" colspan="2">
            <table>
                <tr>
                    <td>Full Address : </td>
                    <td>"<span class="fm-attr-address"></span>"</td>
                    <td style="padding-left: 20px;">Size : </td>
                    <td>"<span class="fm-attr-size"></span>"</td>
                    <td style="padding-left: 20px;">Creation Date/Time : </td>
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
            <form action="FilemanagerHandler.ashx" method="POST"  enctype="multipart/form-data">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                    <h4 class="modal-title">File Upload</h4>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="opName" value="uplaodFile" />
                    <input type="hidden" name="dir" value="/" />
                    <p>
                        <input type="file" name="fileUpload" />
                    </p>
                </div>
                <div class="modal-footer">
                    <input type="submit" value="submit" />
                </div>
            </form>
            <form>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<div class="modal fade" id="newFolderModal">
    <div class="modal-dialog">
        <div class="modal-content">
            </form>
            <form action="FilemanagerHandler.ashx" method="POST"  enctype="multipart/form-data">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                    <h4 class="modal-title">Add New Folder</h4>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="opName" value="addFolder" />
                    <input type="hidden" name="dir" value="/" />
                    <p>Please enter a name for folder</p>
                    <p>
                        <input type="text" name="folderName" />
                    </p>
                </div>
                <div class="modal-footer">
                    <input type="submit" value="submit" />
                </div>
            </form>
            <form>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<div class="modal fade" id="newFileModal">
    <div class="modal-dialog">
        <div class="modal-content">
            </form>
            <form action="FilemanagerHandler.ashx" method="POST"  enctype="multipart/form-data">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                    <h4 class="modal-title">Add New File</h4>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="opName" value="addFile" />
                    <input type="hidden" name="dir" value="/" />
                    <p>Please enter a name for file (default extension is txt)</p>
                    <p>
                        <input type="text" name="fileName" />
                    </p>
                </div>
                <div class="modal-footer">
                    <input type="submit" value="submit" />
                </div>
            </form>
            <form>
        </div>
        <!-- /.modal-content -->
    </div>
    <!-- /.modal-dialog -->
</div>
<script type="text/javascript">
    var currentFiles = [];
    var isLockOnFile = false;
    function ExtendTree(node, data) {
        $(node).children('ul').remove();
        if (data == "")
            return;
        var items = $.parseJSON(data);

        var subTree = $('<ul class="fm-subtree"></ul>');
        $(node).append(subTree);
        $.each(items, function (index, value) {
            $(subTree).append('<li class="fm-dirnode" data-value="' + value.Address + '"><span class="fm-toggle-subtree">-</span><label class="fm-dirname">' + value.Title + '</label></li>');
        });
    }

    function ShowFiles(data, clearData) {
        if (clearData == undefined || clearData) {
            $('.fm-files').children().remove();
            currentFiles = [];
        }
        if (data == "")
            return;
        var items = $.parseJSON(data);
        currentFiles = currentFiles.concat(items);
        $.each(items, function (index, value) {
            $('.fm-files').append('<li class="fm-filenode" data-value="' + value.Address + '"><img src="/Content/filemanager/' + value.Extension + '.png" alt="alternative image" onerror="this.src=\'/Content/filemanager/UNKNOWN.png\'" width="56" /><p class="fm-filename">' + value.Title + '</p></li>');
        });
        //$('.fm-filenode').sortable({ revert: true });
        $('.fm-filenode').draggable({ revert: 'invalid', handle: 'img', zIndex: 1000 });
    }

    function clearAttributes() {
        if (!isLockOnFile)
            $('[class^=fm-attr-]').text('');
    }

    function maskLoad(selector) {
        var offset = $(selector).offset();
        var mask = $('<div class="fm-mask" data-elem="' + selector + '"></div>');
        mask.offset({ top: offset.top, left: offset.left });
        mask.width($(selector).width());
        mask.height($(selector).height());
        $(document.body).prepend(mask);
    }

    function unmask(selector) {
        $('[data-elem="' + selector + '"]').remove();
    }

    $(document).ready(function () {
        loadData($('.fm-tree-directory li:first'));
        $('.fm-tree-directory').on('click', '.fm-dirname', function () {
            clearAttributes();
            var selectedItem = $(this).parent('li');
            if (selectedItem.attr('data-value') == undefined)
                return;
            var folders;
            maskLoad('.fm-right');
            loadData(selectedItem);
        });

        function loadData(elem)
        {
            $.ajax({
                url: '/FilemanagerHandler.ashx',
                data: 'opName=getDirs&dir=/' + elem.attr('data-value'),
                success: function (data, textStatus, jqXHR) {
                    folders = data;
                    ExtendTree(elem, data);
                },
                complete: function () {
                    $.ajax({
                        url: '/FilemanagerHandler.ashx',
                        data: 'opName=getFiles&dir=/' + elem.attr('data-value'),
                        success: function (data, textStatus, jqXHR) {
                            ShowFiles(folders);
                            ShowFiles(data, false);
                            //ShowFiles(data);
                        },
                        complete: function () {
                            unmask('.fm-right');
                        }
                    });
                }
            });
        }

        $('.fm-tree-directory').on('click', '.fm-toggle-subtree', function () {
            clearAttributes();
            if ($(this).parent('li').children('.fm-subtree').length === 0) {
                $(this).next('.fm-dirname').click();
            }
            else { $(this).parent('li').children('.fm-subtree').slideToggle(); }
        });

        $('button').tooltip();
    });



    function getFileSize(fileSize) {
        if (fileSize < 1024)
            return fileSize + "B";
        else if (fileSize < 131072)
            return (fileSize / 1024).toFixed(2) + "KB";
        else
            return (fileSize / 131072).toFixed(2) + "MB";
    }

    function SelectFile(obj) {
        $('.fm-selected').removeClass('fm-selected');
        $(obj).toggleClass('fm-selected');
        var sItem = $.grep(currentFiles, function (a) {
            return a.Address == $(obj).attr('data-value');
        })[0];
        $('.fm-attr-address').text(sItem.Address);
        $('.fm-attr-size').text(getFileSize(sItem.FileSize));
        var createdDateObj = new Date(sItem.DateCreated);
        $('.fm-attr-creationDate').text(createdDateObj.toLocaleDateString() + " " + createdDateObj.toLocaleTimeString());
    }

    $('.fm-files').on('mousedown', '.fm-filenode', function (event) {
        SelectFile(this);
        switch (event.which) {
            case 1:
                break;
            case 3:
                //show context menu
                break;
        }
        return false;
    });

    $('#fm-btn-upload').click(function () {
        $('#uploadModal').modal('show');
    });
    $('#fm-btn-newfolder').click(function () {
        $('#newFolderModal').modal('show');
    });
    $('#fm-btn-newfile').click(function () {
        $('#newFileModal').modal('show');
    });

    $('#fm-btn-openFile').click(function () {
        window.open($('.fm-selected').attr('data-value'));
    });

    $('#fm-btn-download').click(function () {
        window.open('/FilemanagerHandler.ashx?opName=dlFile&dir=' + $('.fm-selected').attr('data-value'));
    });
</script>
