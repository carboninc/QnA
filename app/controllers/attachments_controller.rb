# frozen_string_literal: true

# ------------------------------------------------
class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  expose :file, -> { ActiveStorage::Attachment.find(params[:id]) }

  def destroy
    authorize! :destroy, file
    file.purge
  end
end
