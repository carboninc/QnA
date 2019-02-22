$(document).on('turbolinks:load', function() {
    App.cable.subscriptions.create('CommentsChannel', {
        connected: function() {
            return this.perform('follow', {
                question_id: gon.question_id
            });
        },
        received: function(data) {
            console.log(data);
            if (data.comment.user_id !== gon.user_id) {
                let type = data.comment.commentable_type.toLowerCase();
                let resource = type === 'question' ? $('.question-comments') : $('#answer-block-' + data.comment.commentable_id).find('.answer-comments');
                return resource.append(JST['templates/comment']({
                    comment: data.comment
                }));
            }
        }
    });
});
