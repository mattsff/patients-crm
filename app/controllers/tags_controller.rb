class TagsController < ApplicationController
  def index
    @tags = policy_scope(Tag).ordered
    @tag = Tag.new
  end

  def create
    @tag = Tag.new(tag_params)
    @tag.clinic = Current.clinic
    authorize @tag

    if @tag.save
      redirect_to tags_path, notice: "Tag created."
    else
      @tags = policy_scope(Tag).ordered
      render :index, status: :unprocessable_entity
    end
  end

  def update
    @tag = Tag.find(params[:id])
    authorize @tag

    if @tag.update(tag_params)
      redirect_to tags_path, notice: "Tag updated."
    else
      @tags = policy_scope(Tag).ordered
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @tag = Tag.find(params[:id])
    authorize @tag
    @tag.destroy
    redirect_to tags_path, notice: "Tag deleted."
  end

  private

  def tag_params
    params.require(:tag).permit(:name, :color)
  end
end
