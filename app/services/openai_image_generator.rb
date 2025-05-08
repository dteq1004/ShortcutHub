class OpenaiImageGenerator
  include HTTParty
  base_uri "https://api.openai.com/v1"

  def initialize(prompt)
    @headers = {
      "Authorization" => "Bearer #{Rails.application.credentials.openai_api_key}",
      "Content-Type" => "application/json"
    }
    @prompt = prompt
  end

  def generate_image
    body = {
      model: "gpt-image-1",
      prompt: @prompt,
      n: 1,
      size: "1024x1536",
      quality: "low"
    }
    response = self.class.post(
      "/images/generations",
      headers: @headers,
      body: body.to_json
    )
    response.parsed_response["data"][0]["b64_json"]
  end
end