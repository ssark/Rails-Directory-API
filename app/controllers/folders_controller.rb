class FoldersController < ApplicationController
  def create
    path = params[:path]

    return render json: { error: 'Path not provided' }, status: :bad_request if path.blank?
    return render json: { error: 'Path does not exist' }, status: :bad_request unless path?(path)

    parent = Folder.find_by(title: get_target(params[:path]))
    return render json: { error: "Parent folder doesn't exist" }, status: :bad_request if parent.nil?

    @folder = Folder.new(title: params[:title], folder_id: parent.id)

    return render json: @folder.as_json, status: :created if @folder.save
    render json: @folder.errors, status: :unprocessable_entity
  end

  private

  def folder_params
    params.require(:folder).permit(:title, :path)
  end
end
