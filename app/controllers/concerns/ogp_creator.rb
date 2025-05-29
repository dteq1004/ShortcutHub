class OgpCreator
  require "mini_magick"
  BASE_IMAGE_PATH = "./app/assets/images/base_ogp.png"
  FONT = "./app/assets/fonts/MochiyPopOne-Regular.ttf"
  GRAVITY = "center"
  TEXT_POSITION = "+100+100"
  FONT_SIZE = 60
  INDENTION_COUNT = 10
  ROW_LIMIT = 6

  def self.build(title:, thumbnail_attachment: nil)
    safe_title = sanitize_text(title)
    title = prepare_text(safe_title)
    base_image = MiniMagick::Image.open(BASE_IMAGE_PATH)
    base_image.resize "1200x630"
    # output_path = Rails.root.join("tmp", "ogp_output_#{SecureRandom.hex(4)}.png")
    if thumbnail_attachment&.attached?
      Tempfile.create([ "thumb", ".png" ]) do |thumb_file|
        thumb_file.binmode
        thumb_file.write(thumbnail_attachment.blob.download)
        thumb_file.rewind
        thumb = MiniMagick::Image.open(thumb_file.path)
        thumb.resize "250x375"
        thumb = apply_rounded_corners(thumb, radius: 30)
        base_image = base_image.composite(thumb) do |c|
          c.gravity "west"
          c.geometry "+120+0"
        end
      end
      draw_text_on_right_half(base_image, title)
    else
      text_image = MiniMagick::Image.new(base_image.path)
      text_image.combine_options do |c|
        c.font FONT
        c.fill "black"
        c.gravity "center"
        c.pointsize 60
        c.draw "text 0,0 '#{title}'"
      end
    end
    temp_file = Tempfile.new([ "ogp_output", ".png" ], binmode: true)
    base_image.write(temp_file.path)
    temp_file
  end

  private

  def self.apply_rounded_corners(image, radius:)
    mask = MiniMagick::Image.open(image.path)
    size = mask.dimensions
    mask.combine_options do |c|
      c.alpha "transparent"
      c.background "none"
      c.fill "white"
      c.draw "roundrectangle 0,0,#{size[0]},#{size[1]},#{radius},#{radius}"
    end
    result = image.composite(mask) do |c|
      c.compose "DstIn"
      c.alpha "on"
    end
    result
  end

  def self.draw_text_on_right_half(image, text)
    text_image = MiniMagick::Image.new(image.path)
    text_image.combine_options do |c|
      c.font FONT
      c.fill "black"
      c.gravity "west"
      c.pointsize 60
      c.draw "text 450,0 '#{text}'"
    end
    text_image
  end

  def self.sanitize_text(text)
    text.to_s
      .gsub("\\", "\\\\\\")
      .gsub("'", "\\\\'")
      .gsub('"', '\"')
      .gsub("\n", '\\n')
  end

  def self.prepare_text(text)
    text.to_s.scan(/.{1,#{INDENTION_COUNT}}/)[0...ROW_LIMIT].join("\n")
  end
end
