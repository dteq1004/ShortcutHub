class GenerateOgpImageJob < ApplicationJob
  queue_as :default

  def perform(shortcut_id)
    shortcut = Shortcut.find(shortcut_id)
    return unless shortcut.needs_ogp_update?

    image_file = OgpCreator.build(title: shortcut.title, thumbnail_attachment: shortcut.thumbnail)
    shortcut.ogp_image.attach(io: image_file, filename: "ogp.png", content_type: "image/png")
    shortcut.update(ogp_updated_at: Time.current)
  ensure
    image_file&.close
    image_file&.unlink
  end
end
