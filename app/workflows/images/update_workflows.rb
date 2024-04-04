class Images::UpdateWorkflows
  attr_reader :image, :image_params

  def initialize(image, image_params)
    @image = image
    @image_params = image_params
  end

  def call
    update_image
    generate_image_tags if image_params[:file].present? || image.tag_list.empty?
    image
  end

  private

  def update_image
    image.update!(image_params)
  end

  def generate_image_tags
    taggings = GeminiAiClient.new.taggings(image)
    image.tag_list.add(taggings)
    image.save!
  end
end
