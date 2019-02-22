# frozen_string_literal: true

# ------------------------------------------------
module AnswersHelper
  def cable_files_url(answer)
    answer.files.map do |file|
      { name: file.filename.to_s, url: url_for(file) }
    end
  end

  def cable_links_and_gists(answer)
    answer.links.map do |link|
      { id: link.id, name: link.name, url: link.url, gist_content: link.gist? ? link.gist_content : '' }
    end
  end
end
