class News
  require 'net/http'

  attr_accessor :id, :title, :body, :published_at, :category

  def initialize(id:, title:, body:, published_at:, category:)
    @id = id
    @title = title
    @body = body
    @published_at = published_at
    @category = category
  end

  def self.page(offset: 0, limit: 10)
    uri = URI.parse("#{Rails.application.credentials.dig(:microcms, :news_url)}?offset=#{offset}&limit=#{limit}")
    header = { 'X-MICROCMS-API-KEY': Rails.application.credentials.dig(:microcms, :api_key) }
    res = Net::HTTP.get_response(uri, header)

    raise ActiveRecord::RecordNotFound if res.code.to_i == 404
    raise StandardError unless res.code.to_i == 200

    body = JSON.parse(res.body, symbolize_names: true)

    news = body[:contents].map do |content|
      new(
        id: content[:id],
        title: content[:title],
        body: content[:body],
        published_at: content[:publishedAt],
        category: content[:category]
      )
    end
  end

  def self.find(id)
    uri = URI.parse("#{Rails.application.credentials.dig(:microcms, :news_url)}/#{id}")
    header = { 'X-MICROCMS-API-KEY': Rails.application.credentials.dig(:microcms, :api_key) }
    res = Net::HTTP.get_response(uri, header)

    raise ActiveRecord::RecordNotFound if res.code.to_i == 404
    raise StandardError unless res.code.to_i == 200

    body = JSON.parse(res.body, symbolize_names: true)

    new(
      id: body[:id],
      title: body[:title],
      body: body[:body],
      published_at: body[:publishedAt],
      category: body[:category]
    )
  end
end