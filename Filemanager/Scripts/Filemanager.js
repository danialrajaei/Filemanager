var copies = {}, cuts = {}, paste = {};
handlerURL = '/FilemanagerHandler.ashx';
function ExtendTree(node, data) {
    $(node).children('ul').remove();
    if (data == "")
        return;
    var items = $.parseJSON(data);

    var subTree = $('<ul class="fm-subtree"></ul>');
    $(node).append(subTree);
    $.each(items, function (index, value) {
        $(subTree).append('<li class="fm-dirnode" data-value="' + value.Address + '"><div class="fm-toggle-subtree fm-icon-minifolder pull-left"></div><label class="fm-dirname">' + value.Title + '</label></li>');
    });
}

function ShowFiles(data, clearData) {
    if (clearData == undefined || clearData) {
        $('.fm-files').children().remove();
    }
    if (data == "")
        return;
    var items = $.parseJSON(data);
    $.each(items, function (index, value) {
        $('.fm-files').append('<li class="fm-filenode ui-widget-content" data-value="' + value.Address + '" data-size="' + value.FileSize + '" data-date="' + value.DateCreated + '" data-ext="' + value.Extension + '"><img src="/Content/filemanager/' + value.Extension + '.png" alt="alternative image" onerror="this.src=\'/Content/filemanager/UNKNOWN.png\'" width="56" /><p class="fm-filename">' + value.Title + '</p></li>');
    });
    //$('.fm-filenode').draggable({ revert: 'invalid', handle: 'img', zIndex: 1000 });
}

function clearAttributes() {
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

function loadData(elem) {
    var folders;
    $.ajax({
        url: handlerURL,
        data: 'opName=getDirs&dir=/' + elem.attr('data-value'),
        success: function (data, textStatus, jqXHR) {
            folders = data;
            ExtendTree(elem, data);
            $('.fm-tree-selected').removeClass('fm-tree-selected');
            $(elem).toggleClass('fm-tree-selected');
        },
        complete: function () {
            $.ajax({
                url: handlerURL,
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
    paste = '/' + elem.attr('data-value');
    $('[name=dir]').val('/' + elem.attr('data-value'));
}

$(document).ready(function () {
    loadData($('.fm-tree-directory li:first'));
    $('.fm-tree-directory').on('click', '.fm-dirname', function () {
        clearAttributes();
        var selectedItem = $(this).parent('li');
        if (selectedItem.attr('data-value') == undefined)
            return;
        maskLoad('.fm-right');
        loadData(selectedItem);
    });

    $('.fm-tree-directory').on('click', '.fm-toggle-subtree', function () {
        clearAttributes();
        if ($(this).parent('li').children('.fm-subtree').length === 0) {
            $(this).next('.fm-dirname').click();
        }
        else { $(this).parent('li').children('.fm-subtree').slideToggle(); }
    });
    $('.fm-files').selectable({ cancel: ".ui-selected" });
    $('[data-translate-title]').each(function (index, value) { $(value).attr('title', (Lang[$(value).attr('data-translate-title')])); });
    $('[data-translate-text]').each(function (index, value) { $(value).text(Lang[$(value).attr('data-translate-text')]); });
    $('[data-translate-value]').each(function (index, value) { $(value).val(Lang[$(value).attr('data-translate-value')]); });

    $('button').tooltip();
    $('.fm-btngroup-open>button').prop('disabled', true);
    $('.fm-btngroup-edit>button').prop('disabled', true);
    $('#fm-btn-rename').prop('disabled', true);
    $('#fm-btn-delete').prop('disabled', true);
});

function getFileSize(fileSize) {
    if (fileSize < 1024)
        return fileSize + "B";
    else if (fileSize < 131072)
        return (fileSize / 1024).toFixed(2) + "KB";
    else
        return (fileSize / 131072).toFixed(2) + "MB";
}

function ShowFileAttrib() {
    var obj = $('.fm-files').find('li.ui-selected');
    $('.fm-attr-address').text($(obj).attr('data-value'));
    $('.fm-attr-size').text(getFileSize($(obj).attr('data-size')));
    var createdDateObj = new Date($(obj).attr('data-date'));
    $('.fm-attr-creationDate').text(createdDateObj.toLocaleDateString() + " " + createdDateObj.toLocaleTimeString());
    if ($(obj).attr('data-ext').toLowerCase() == 'folder')
        paste = $(obj).attr('data-value');
}

function ShowFilesAttrib() {
    var obj = $('.fm-files').find('li.ui-selected');
    $('.fm-attr-address').text('');
    var si = 0;
    $('.fm-files>li.ui-selected').each(function (index, value) { si += parseInt($(value).attr('data-size')); });
    $('.fm-attr-size').text(getFileSize(si));
    $('.fm-attr-creationDate').text('-');
    if ($(obj).attr('data-ext').toLowerCase() == 'folder')
        paste = $(obj).attr('data-value');
}

function Reload() {
    maskLoad('.fm-right');
    loadData($('.fm-tree-selected'));
}

//$('.fm-files').on('mousedown', '.fm-filenode', function (event) {
//    //SelectFile(this);
//    switch (event.which) {
//        case 1:
//            break;
//        case 3:
//            //show context menu
//            break;
//    }
//});

$(".fm-files").on("selectablestop", function (event, ui) {
    var selectedNumber = $('.fm-files').find('li.ui-selected').length;
    if (selectedNumber == 0) {
        $('.fm-btngroup-open>button').prop('disabled', true);
        $('.fm-btngroup-edit>button').prop('disabled', true);
        $('#fm-btn-rename').prop('disabled', true);
        $('#fm-btn-delete').prop('disabled', true);
        $('#fm-btn-paste').prop('disabled', copies.length == 0 && cuts.length == 0);
        clearAttributes();
    }
    else if (selectedNumber == 1) {
        $('.fm-btngroup-open>button').prop('disabled', false);
        $('.fm-btngroup-edit>button').prop('disabled', false);
        $('#fm-btn-rename').prop('disabled', false);
        $('#fm-btn-delete').prop('disabled', false);
        $('#fm-btn-paste').prop('disabled', copies.length == 0 && cuts.length == 0);
        ShowFileAttrib();
    }
    else if (selectedNumber > 1) {
        $('.fm-btngroup-open>button').prop('disabled', true);
        $('.fm-btngroup-edit>button').prop('disabled', true);
        $('#fm-btn-rename').prop('disabled', true);
        $('#fm-btn-delete').prop('disabled', false);
        $('#fm-btn-paste').prop('disabled', copies.length == 0 && cuts.length == 0);
        ShowFilesAttrib();
    }
});

function getUrlParam(paramName) {
    var reParam = new RegExp('(?:[\?&]|&)' + paramName + '=([^&]+)', 'i');
    var match = window.location.search.match(reParam);

    return (match && match.length > 1) ? match[1] : null;
}

$('.fm-files').on('dblclick', '.fm-filenode', function (event) {
    if ($(this).attr('data-ext') == "folder") {
        $('.fm-dirnode[data-value="' + $(this).attr('data-value') + '"]>.fm-toggle-subtree').click();
    } else {
        var funcNum = getUrlParam('CKEditorFuncNum');
        window.opener.CKEDITOR.tools.callFunction(funcNum, "/" + $(this).attr('data-value'));
        window.close();
    }
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
    window.open("/" + $('.fm-files').find('li.ui-selected').attr('data-value'));
});

$('#fm-btn-download').click(function () {
    window.open(handlerURL+'?opName=dlFile&dir=' + $('.fm-files').find('li.ui-selected').attr('data-value'));
});

$('#fm-btn-copy').click(function () {
    copy($('.fm-files').find('li.ui-selected'));
});

$('#fm-btn-cut').click(function () {
    cut($('.fm-files').find('li.ui-selected'));
});

$('#fm-btn-paste').click(function () {
    if (copies.length > 0) {
        copies.each(function () {
            $.ajax({
                url: handlerURL,
                data: 'opName=copy&dir1=/' + paste + '&dir2=/' + $(this).attr('data-value'),
            });
        });
        maskLoad('.fm-right');
        loadData($('.fm-tree-selected'));
    }
    else if (cuts.length > 0) {
        cuts.each(function () {
            $.ajax({
                url: handlerURL,
                data: 'opName=cut&dir1=/' + paste + '&dir2=/' + $(this).attr('data-value'),
            });
        });
        maskLoad('.fm-right');
        loadData($('.fm-tree-selected'));
    }
});

$('#btnSearch').click(function () {
    $('.fm-files>li').hide();
    $('.fm-files>li>p:contains("' + $('#txtSearch').val() + '")').parent('li').show();
});

$('#fm-btn-delete').click(function () {
    $('.fm-files').find('li.ui-selected').each(function (index, value) {
        $.ajax({
            url: handlerURL,
            data: 'opName=delete&dir=/' + $(value).attr('data-value'),
            complete: function () {
                maskLoad('.fm-right');
                loadData($('.fm-tree-selected'));
            }
        });
    });
    maskLoad('.fm-right');
    loadData($('.fm-tree-selected'));
});

$('#fm-btn-rename').click(function () {
    var obj = $('.fm-files').find('li.ui-selected').append('<textarea class="fm-txt-rename form-control" type="text" >' + $('.fm-files>li.ui-selected>.fm-filename').text() + '</textarea>');
    $('.fm-files>li.ui-selected>.fm-filename').hide();
    $('.fm-files>li.ui-selected>textarea').focus();
    $('.fm-files>li.ui-selected>textarea').select();
    $('.fm-txt-rename').blur(function () {
        renameFile(this);
    });
    $('.fm-txt-rename').keypress(function (e) {
        if (e.which == 13) {
            renameFile(this);
        }
    });
});

function renameFile(obj) {
    var rename = $(obj).val();
    $(obj).hide();
    $.ajax({
        url: handlerURL,
        data: 'opName=rename&dir=/' + $(obj).parent('.fm-filenode').attr('data-value') + '&name=' + rename,
        success: function (data) {
            var item = $.parseJSON(data)[0];
            $(obj).prev('p').text(item.Title).show().parent('.fm-filenode').attr('data-value', item.Address).attr('data-ext', item.Extension).attr('data-date', item.CreatedDate);
            $(obj).remove();
        }
    });
}

$('#fm-btn-duplicate').click(function () {
    $.ajax({
        url: handlerURL,
        data: 'opName=copy&dir1=/' + $('.fm-tree-selected').attr('data-value') + '&dir2=/' + $('.fm-files').find('li.ui-selected').attr('data-value'),
        complete: function () {
            maskLoad('.fm-right');
            loadData($('.fm-tree-selected'));
        }
    });
});

function copy(obj) {
    $('.fm-copy').removeClass('fm-copy');
    $('.fm-cut').removeClass('fm-cut');
    $(obj).addClass('fm-copy');
    cuts = {};
    copies = $(obj);
}

function cut(obj) {
    $('.fm-copy').removeClass('fm-copy');
    $('.fm-cut').removeClass('fm-cut');
    $(obj).addClass('fm-cut');
    copies = {};
    cuts = $(obj);
}

$('form[name="uploadFrm"]').submit(function (event) {
    if (window.FormData !== undefined) {
        event.preventDefault();
        var data = new FormData();
        $.each($(this).find('input[name="fileUpload"]')[0].files, function(key, value) {
            data.append(key, value);
        });
        data.append('dir', $(this).find('input[name="dir"]').val());
        $(this).find('.progress').removeClass('hide');
        var form = $(this);
        var progressBar = $(this).find('.progress-bar');
        $(progressBar).attr('aria-valuenow', 0).text("0%").css('width', "0%");
        $.ajax({
            url: handlerURL+'?opName=uplaodFile',
            type: 'POST',
            data: data,
            cache: false,
            dataType: 'json',
            processData: false,
            contentType: false,
            xhrFields: {
                onprogress: function(e) {
                    if (e.lengthComputable) {
                        var percentComplete = (e.loaded / e.total * 100);
                        $(progressBar).attr('aria-valuenow', percentComplete).text(percentComplete + "%").css('width', percentComplete + "%");
                    } else {
                        console.log('Length not computable.');
                    }
                }
            },
            success: function(data, textStatus, jqXHR) {
                Reload();
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.log('ERRORS: ' + textStatus);
            },
            complete: function() {
                $(form).trigger('reset');
                $(form).find('.progress').addClass('hide');
                $('#uploadModal').modal('hide');
            }
        });
    }
});

$('form[name="newFolderFrm"]').submit(function (event) {
    event.preventDefault();
    var form = this;
    $.ajax({
        url: handlerURL,
        type: 'POST',
        data: $(form).serialize(),
        success: function (data, textStatus, jqXHR) {
            Reload();
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log('ERRORS: ' + textStatus);
        },
        complete: function () {
            $(form).trigger('reset');
            $('#newFolderModal').modal('hide');
        }
    });
});
$('form[name="newFileFrm"]').submit(function (event) {
    event.preventDefault();
    var form = this;
    $.ajax({
        url: handlerURL,
        type: 'POST',
        data: $(form).serialize(),
        success: function (data, textStatus, jqXHR) {
            Reload();
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.log('ERRORS: ' + textStatus);
        },
        complete: function () {
            $(form).trigger('reset');
            $('#newFileModal').modal('hide');
        }
    });
});