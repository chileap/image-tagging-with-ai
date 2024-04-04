class TagsController < ApplicationController
  before_action :set_tag, only: %i[ show edit update destroy ]

  # GET /tags or /tags.json
  def index
    @sort = params[:sort] == "asc" ? "desc" : "asc"
    @tags = current_user.all_tags.order("name #{@sort}").page(params[:page]).per(10)
  end

  # GET /tags/1 or /tags/1.json
  def show
    @images = current_user.images.tagged_with(@tag.name)
    @q = @images.ransack(params[:q])
    @q.sorts = 'title asc' if @q.sorts.empty?

    result = @q.result(distinct: true)
    @images = result.page(params[:page]).per(10)
  end

  # GET /tags/new
  def new
    @tag = current_user.owned_tags.new
    @tag.taggings.build
  end

  # GET /tags/1/edit
  def edit
  end

  # POST /tags or /tags.json
  def create
    if Tags::CreateWorkflow.new(tag_params, current_user).call
      respond_to do |format|
        format.html { redirect_to tags_url, notice: "Tag was successfully created." }
        format.json { render :show, status: :created, location: @tag }
        format.turbo_stream { redirect_to tags_url, notice: "Tag was successfully created." }
      end
    else
      respond_to do |format|
        format.html {
          redirect_to tags_url, alert: "There are something wrong."
        }
        format.json {
          render json: { messages: "There are something wrong." },
          status: :unprocessable_entity
        }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tags/1 or /tags/1.json
  def update
    if Tags::UpdateWorkflow.new(@tag, tag_params, current_user).call
      respond_to do |format|
        format.html { redirect_to tags_url, notice: "Tag was successfully updated." }
        format.json { render :show, status: :ok, location: @tag }
        format.turbo_stream { redirect_to tags_url, notice: "Tag was successfully updated." }
      end
    else
      respond_to do |format|
        format.html {
          redirect_to tags_url, alert: "There are something wrong."
        }
        format.json {
          render json: { messages: "There are something wrong." },
          status: :unprocessable_entity
        }
        format.turbo_stream { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1 or /tags/1.json
  def destroy
    @tagging = @tag.taggings
    if @tagging.present?
      @tagging.destroy_all
    end
    if @tag.taggings.empty?
      @tag.destroy!
    end

    respond_to do |format|
      format.html { redirect_to tags_url, notice: "Tag was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = current_user.all_tags.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def tag_params
      params.require(:acts_as_taggable_on_tag).permit(:name, taggings: [:image_id])
    end
end
