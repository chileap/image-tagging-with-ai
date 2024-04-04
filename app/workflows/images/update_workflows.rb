class Images::UpdateWorkflows
  attr_reader :image, :image_params

  def initialize(image, image_params)
    @image = image
    @image_params = image_params
  end

  def call
    update_image
    if ENV["GEMINI_AI_API_KEY"].present? && (image_params[:file].present? || image.tag_list.empty?)
      generate_image_tags
    end
    image
  end

  private

  def update_image
    image.update!(image_params)
  end

  def generate_image_tags
    taggings = GeminiAiClient.new.taggings(image)
    image.user.tag(image, with: taggings, on: :tags)
    image.save!
  end
end
