class FoldersController < ApplicationController

  # GET /folders
  def index
    @folders = Folder.all
    render json: @folders.map(&:as_json)
  end

  def is_path?(path)
    str = ""
    return false if path.blank?

    curr = nil

    folder_titles = path.split('/').to_a
    folder_titles.shift

    folder_titles.each { |s|
      if s.equal?(folder_titles.first) && curr == nil
        curr = Folder.find_by(title: s)
        return false if curr.nil?
      else
        child = Folder.find_by(title: s)
        return false if child.nil?
        if curr.children.include?(child) && child.parent = curr
          curr = child
        else
          return false
        end
      end
    }
    true
  end

  def get_parent(path)
    path.split('/').to_a.last
  end

  # POST /folders
  def create
    if !params[:path].blank?
      if is_path?(params[:path])
        parent = Folder.find_by(title: get_parent(params[:path]))
        return render json: { message: "Parent folder doesn't exist"}, status: :unprocessable_entity if parent.nil?
        @folder = Folder.new(title: params[:title], folder_id: parent.id)
      else
        return render json: {error: 'Path does not exist'}, status: :unprocessable_entity
      end
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
      params.require(:folder).permit(:title, :path)
    end
end
