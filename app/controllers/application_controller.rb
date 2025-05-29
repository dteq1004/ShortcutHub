class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render404
  before_action :set_header_visibility

  def after_register_path_for(_resource)
    root_path
  end

  def render404
    render template: "errors/error404", layout: "error", status: :not_found
  end

  private

  def set_header_visibility
    @show_header = true # デフォルトはヘッダーを表示する
  end
end
