# frozen_string_literal: true

# ------------------------------------------------
class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, presence: true, url: true

  def gist?
    url =~ /gist.github.com/
  end

  def gist_content
    GistContentService.new(url.split('/').last).content if gist?
  end
end
