module ApplicationHelper
  def flash_background_color(type)
    case type.to_sym
    when :notice then "bg-zinc-500"
    when :alert  then "bg-rose-400"
    when :error  then "bg-yellow-500"
    else "bg-gray-500"
    end
  end

  def default_meta_tags
    {
      site: "Shortcut Hub（ショートカットハブ）",
      title: "iPhoneのショートカットのレシピを共有できるプラットフォーム",
      reverse: true,
      charset: "utf-8",
      description: "Shortcut Hub（ショートカットハブ）ではiPhoneをもっと便利にするためのショートカットのレシピを共有できるプラットフォームです。",
      keywords: "iPhone,ショートカット",
      canonical: request.original_url,
      separator: "|",
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: "website",
        url: request.original_url,
        image: image_url("ogp.png"),
        local: "ja-JP"
      },
      twitter: {
        card: "summary_large_image",
        image: image_url("ogp.png")
      }
    }
  end
end
