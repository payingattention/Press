
// JS for the category modal system
$(function() {

    // Hook up ajax click of submit button
    $('#category_modal .submit').click(function(obj) {

        var target_url = $('#category_modal').attr('action');
        var data = $('#category_modal').serialize();

        $.ajax({
            type: 'POST',
            url: target_url,
            dataType: 'json',
            data: data,
            error: function(xhr) {
                var err = JSON.parse(xhr.responseText);
                for(or in err) {
                    $('#taxonomy_' + or).parent().parent().addClass('error');
                    $('#taxonomy_' + or).siblings('span').html(err[or][0]);
                }
            },
            success: function () {
                $('.categories-form-partial').empty();

                $.ajax({
                    type: 'GET',
                    url:$(obj.target).attr('data-partial-url'),
                    error: function() {
                        window.location.reload();
                    },
                    success: function(response) {
                        $('.categories-form-partial').html(response);
                        $('#category-modal').modal('hide');
                    }
                })
            }
        });
        return false;
    });

});
