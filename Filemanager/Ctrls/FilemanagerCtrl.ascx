<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="FilemanagerCtrl.ascx.cs" Inherits="Filemanager.Ctrls.FilemanagerCtrl" %>
<table class="col-xs-12 col-sm-12 col-md-12 col-lg-12 fm-table">
    <tr>
        <td class="col-xs-12 col-sm-12 col-md-3 col-lg-3 fm-left">
            <ul class="fm-tree-directory"><li>Root</li></ul>
        </td>
        <td class="col-xs-12 col-sm-12 col-md-9 col-lg-9 fm-right">
            <ul class="fm-files"></ul>
        </td>
    </tr>
</table>
<script type="text/javascript">
    function ExtendTree(node, data) {
        $(node).children('ul').remove();
        if (data == "")
            return;
        var items = $.parseJSON(data);
        var subTree = $('<ul class="fm-subtree"></ul>');
        $(node).append(subTree);
        $.each(items, function(index, value) {
            $(subTree).append('<li class="fm-dirnode"><label class="fm-dirname">' + value.Address + '</label></li>');
        });
    }
    
    function ShowFiles(data) {
        $('.fm-files').children().remove();
        if (data == "")
            return;
        var items = $.parseJSON(data);
        $.each(items, function (index, value) {
            $('.fm-files').append('<li><label class="fm-filename">' + value.Address + '</label></li>');
        });
    }

    $(document).ready(function() {
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
    });

    $('.fm-dirname').on('click', 'li', function () {
        var selectedItem = $(this).up('li');
        $.ajax({
            url: '/FilemanagerHandler.ashx',
            data: 'opName=getDirs&dir=/'+ selectedItem.children('.fm-dirname').text(),
            success: function (data, textStatus, jqXHR) {
                ExtendTree(selectedItem, data);
            },
        });
    });
</script>
