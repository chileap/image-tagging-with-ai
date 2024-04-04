class Images::CreateWorkflows
  attr_reader :image_params

  def initialize(image_params)
    @image_params = image_params
  end

  def call
    create_image
    generate_image_tags
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

    @image.tag_list.add(taggings)
    @image.save!
  end
end