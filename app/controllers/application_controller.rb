class ApplicationController < ActionController::Base
  before_action :set_header_visibility

  def after_register_path_for(resource)
    root_path
  end

  private

  def set_header_visibility
    @show_header = true # デフォルトはヘッダーを表示する
  end
end
