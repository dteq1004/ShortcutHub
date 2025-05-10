module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice then "bg-zinc-500"
    when :alert  then "bg-rose-400"
    when :error  then "bg-yellow-500"
    else "bg-gray-500"
    end
  end
end
