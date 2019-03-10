# frozen_string_literal: true

# ------------------------------------------------
module ApplicationHelper
  def show_result(result)
    type = result.class.name

    type_checking(type, result)
  end

  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end

  private

  def type_checking(type, result)
    case type
    when 'User'
      tag.p(type) + result.email + tag.hr
    when 'Question'
      tag.p(type) + link_to_question(result) + ' ' + result.body + tag.hr
    when 'Answer'
      tag.p(type) + result.body + ' in ' + link_to_question(result.question) + tag.hr
    else
      checking_for_comments(type, result)
    end
  end

  def checking_for_comments(type, result)
    commentable_type = result.commentable_type.downcase
    commentable = result.commentable

    if commentable_type == 'question'
      tag.p(type) + result.body + ' in ' + commentable_type + ' ' + link_to_question(commentable) + tag.hr
    else
      tag.p(type) + result.body + ' in ' + commentable_type + ' ' + link_to_question(commentable.question) + tag.hr
    end
  end

  def link_to_question(question)
    link_to(question.title, question_path(question), target: '_blank')
  end
end
