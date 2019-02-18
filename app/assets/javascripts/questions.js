$(document).on('turbolinks:load', function() {
    $('.questions').on('click', '.edit-question-link', function(e) {
        e.preventDefault();
        $(this).hide();
        let questionId = $(this).data('questionId');
        $('form#edit-question-' + questionId).removeClass('hidden');
    });

    $('.vote-up, .vote-down').on('ajax:success', function(e) {
        var resource = e.detail[0];
        var resourceId = resource.id;

        $('.rating-' + resourceId).html(resource.rating);
    })
        .on('ajax:error', function (e) {
            var errors = e.detail[0];

            $.each(errors, function(index, value) {
                $('.errors').html('<p>' + value + '</p>');
            })

        });
});
