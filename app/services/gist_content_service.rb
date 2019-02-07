# frozen_string_literal: true

# ------------------------------------------------
class GistContentService
  def initialize(gist)
    @gist = gist
    @client = Octokit::Client.new
  end

  def content
    gist_content = @client.gist(@gist)
    gist_content.files.first[1].content
  rescue StandardError
    nil
  end
end
