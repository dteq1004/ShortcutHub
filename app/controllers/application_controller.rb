class ApplicationController < ActionController::Base
  before_action :set_header_visibility

  private

  def set_header_visibility
    @show_header = true # デフォルトはヘッダーを表示する
  end
end
