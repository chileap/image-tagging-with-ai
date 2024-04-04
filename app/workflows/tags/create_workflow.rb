class Tags::CreateWorkflow
  attr_reader :tag_params, :current_user

  def initialize(tag_params, current_user)
    @tag_params = tag_params
    @current_user = current_user
  end

  def call
    if tag_params[:taggings].present? && tag_params[:taggings][:image_id].present?
      @image = current_user.images.find(tag_params[:taggings][:image_id])
      image_tagging = @image.tags.pluck(:name).push(tag_params[:name]).join(", ")
      if current_user.tag(@image, with: image_tagging, on: :tags)
        @tag = current_user.owned_tags.find_by(name: tag_params[:name])
      else
        @tag = current_user.owned_tags.new(name: tag_params[:name])
        @tag.save
      end
    else
      @tag = current_user.owned_tags.new(name: tag_params[:name])
      @tag.save
    end

    @tag
  end
end