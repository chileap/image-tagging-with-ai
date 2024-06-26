class Images::CreateWorkflows
  attr_reader :image_params

  def initialize(image_params)
    @image_params = image_params
  end

  def call
    create_image
    if ENV["GEMINI_AI_API_KEY"].present? && image_params[:file].present?
      generate_image_tags
    end
    @image
  end

  private
  attr_reader :image

  def create_image
    @image = Image.new(image_params)
    @image.save!
  end

  def generate_image_tags
    taggings = GeminiAiClient.new.taggings(@image)
    image.user.tag(image, with: taggings, on: :tags)
    @image.save!
  end
end