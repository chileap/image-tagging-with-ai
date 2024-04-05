require 'base64'

class GeminiAiClient
  attr_reader :client

  PROMPT = 'Your job is to provide information about the photo and rate it on the following metrics in number
  - key_subject (List key subjects and their colour. Eg, "Yellow Chair", "Red apple")
  - key_subject_category (Does the key subject have a more specific category it belongs to? Eg a Victorian Period House.)
  - photo_style (max 3 words. Eg "Architectural photography")
  - emotion (Comma separated list to describe the emotions of this image)
  - photo_colors (comma separated list of key subjects and their colour. eg "Blue sky")
  - products_and_materials (Comma separated list of products in the image)
  - brands (comma separated list of any identifiable brands in the image. This may be the name of a brand, or a known brand of the subject like a Porsche. Return models if known, eg, Porsche 911. Return nil if none identified.)
  - people (Describe any people in the image. Eg, ethnicity, age, gender etc. Return nil if none)
Other instructions
  - We are particular about the difference between real estate photography and architectural photography.
  - We are looking for a detailed description of the image. The more detailed the better.

  Please return as array of value of tag name without any explanation in json format';

  def initialize
    @client = Gemini.new(
      credentials: {
        service: 'generative-language-api',
        api_key: ENV['GEMINI_API_KEY'],
      },
      options: { model: 'gemini-pro-vision', server_sent_events: true }
    )
  end

  def taggings(image)
    image_file = nil
    if Rails.env.development?
      image_file = File.read(image.file.to_io)
    else
      image_file = image.file.download
    end

    result = @client.stream_generate_content(
      { contents: [
        { role: 'user', parts: [
          { text: PROMPT },
          { inline_data: {
            mime_type: image.file.metadata['mime_type'],
            data: Base64.strict_encode64(File.read(image_file))
          } }
        ] }
      ] }
    )
    response = format_response(result)
    handle_response(response)
  end

  private

  def format_response(response)
    taggings = ''
    response.each do |r|
      taggings += r['candidates'][0]['content']['parts'][0]['text']
    end

    taggings
  end

  def parse_response(response)
    JSON.parse response.split("\n").join.split("```json").join.split("```").join
  end

  def handle_response(response)
    parse_response(response).values.flatten!.filter { |r| r != 'nil' || r != 'null' || r != nil }
  end
end
