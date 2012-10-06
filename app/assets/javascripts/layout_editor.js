$(document).ready(function() {
    if ($("#layout-palette").length > 0) {
        $("#layout-palette div.widget-admin-button").draggable({
            revert: "invalid",
            helper: "clone"
        });
    }

    if ($("#layout-canvas").length > 0) {

        $(".droppable").droppable({
            accept: ".widget-admin-button",
            hoverClass: 'dropping',
            drop: function (e,ui) {
                cloneWidget ( this, ui.draggable );
            }
        });
    }
});

function cloneWidget( dropzone, widget ) {
    var newWidget = $(widget).clone()
        .removeClass('well-small widget-admin-button')
        .insertBefore($(dropzone).children('.dropzone').first())
        .droppable({
            accept: ".widget-admin-button",
            hoverClass: 'dropping',
            drop: function (e,ui) {
                cloneWidget ( ui.draggable );
            }
        });
    $("<div class='well dropzone'>Dropzone</div>").appendTo($(newWidget));
}