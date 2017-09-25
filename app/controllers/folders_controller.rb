class FoldersController < ApplicationController

  # GET /folders
  def index
    @folders = Folder.all

    render json: @folders.map(&:as_json)
  end

  # POST /folders
  def create
    if !params[:parent].blank?
      parent = Folder.find_by(title: params[:parent])
      return render json: { message: "Parent folder doesn't exist"}, status: :unprocessable_entity if parent.nil?
      @folder = Folder.new(title: params[:title], folder_id: parent.id)
    else
      @folder = Folder.new(title: params[:title])
    end

    if @folder.save
      render json: @folder.as_json, status: :created, location: @folder
    else
      render json: @folder.errors, status: :unprocessable_entity
    end
  end

  private
    def folder_params
      params.require(:folder).permit(:title, :parent)
    end
end
