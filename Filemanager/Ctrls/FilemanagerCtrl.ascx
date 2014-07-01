<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FilemanagerCtrl.ascx.cs" Inherits="Filemanager.Ctrls.FilemanagerCtrl" %>
<table class="col-xs-12 col-sm-12 col-md-12 col-lg-12 fm-table">
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
<script type="text/javascript">
    var currentFiles;
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
        if (clearData == undefined || clearData)
        {
            $('.fm-files').children().remove();
            currentFiles = [];
        }
        if (data == "")
            return;
        var items = $.parseJSON(data);
        currentFiles.concat(items);
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

    function maskLoad(selector)
    {
        var offset = $(selector).offset();
        var mask = $('<div class="fm-mask" data-elem="'+selector+'"></div>');
        mask.offset({ top: offset.top, left: offset.left });
        mask.width($(selector).width());
        mask.height($(selector).height());
        $(document.body).prepend(mask);
    }

    function unmask(selector)
    {
        $('[data-elem="' + selector + '"]').remove();
    }

    $(document).ready(function () {
        $.ajax({
            url: '/FilemanagerHandler.ashx',
            data: 'opName=getDirs&dir=<%= this.RootPath %>',
            success: function (data, textStatus, jqXHR) {
                ExtendTree($('.fm-tree-directory li:first'), data);
            },
        });
        $.ajax({
            url: '/FilemanagerHandler.ashx',
            data: 'opName=getFiles&dir=<%= this.RootPath %>',
            success: function (data, textStatus, jqXHR) {
                ShowFiles(data);
            },
        });
        $('.fm-tree-directory').on('click', '.fm-dirname', function () {
            clearAttributes();
            var selectedItem = $(this).parent('li');
            if (selectedItem.attr('data-value') == undefined)
                return;
            var folders;
            maskLoad('.fm-right');
            $.ajax({
                url: '/FilemanagerHandler.ashx',
                data: 'opName=getDirs&dir=/' + selectedItem.attr('data-value'),
                success: function (data, textStatus, jqXHR) {
                    folders = data;
                    ExtendTree(selectedItem, data);
                },
                complete: function () {
                    $.ajax({
                        url: '/FilemanagerHandler.ashx',
                        data: 'opName=getFiles&dir=/' + selectedItem.attr('data-value'),
                        success: function (data, textStatus, jqXHR) {
                            ShowFiles(folders);
                            ShowFiles(data, false);
                            //ShowFiles(data);
                        },
                        complete:function()
                        {
                            unmask('.fm-right');
                        }
                    });
                }
            });
        });

        $('.fm-tree-directory').on('click', '.fm-toggle-subtree', function () {
            clearAttributes();
            if ($(this).parent('li').children('.fm-subtree').length === 0) {
                $(this).next('.fm-dirname').click();
            }
            else { $(this).parent('li').children('.fm-subtree').slideToggle(); }
        });
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
</script>
