class NotesController < ApplicationController
  before_action :set_note, only: [:show, :update, :move]

  # GET /notes
  def index
    @notes = Note.all
    render json: @notes
  end

  # GET /notes/1
  def show
    render json: @note
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

  def get_dir(path)
    path.split('/').to_a.last
  end

  # POST /notes
  def create
    if !params[:path].blank?
      if is_path?(params[:path])
        folder = Folder.find_by(title: get_dir(params[:path]))
        return render json: { message: "Target folder doesn't exist"}, status: :unprocessable_entity if folder.nil?
      else
        return render json: {error: 'Path does not exist'}, status: :unprocessable_entity
      end
    else
      render json: {error: 'No path specified'}, status: :unprocessable_entity
    end

    @note = Note.new(title: params[:title], content: params[:content], folder_id: folder.id)

    if @note.save
      render json: @note.as_json, status: :created, location: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  def update
    if !params[:new_title].blank? && !params[:content].blank?
      update_params = {title: params[:new_title], content: params[:content]}
    elsif !params[:new_title].blank?
      update_params = {title: params[:new_title]}
    else
      update_params = {content: params[:content]}
    end

    if @note.update(update_params)
      render json: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  def move
    return render json: {error: "Note #{params[:title]} doesn't exist"}, status: :unprocessable_entity if @note.nil?
    from = Folder.find_by(title: get_dir(params[:from])) if is_path?(params[:from])
    to = Folder.find_by(title: get_dir(params[:to])) if is_path?(params[:to])

    return render json: {error: "From path doesn't exist"}, status: :unprocessable_entity if from.nil?
    return render json: {error: "To path doesn't exist"}, status: :unprocessable_entity if to.nil?

    if from.notes.include?(@note) && @note.folder = from
      @note.update(folder_id: to.id)
      render json: @note
    else
      render json: {error: "Note #{@note.title} can't be found in folder #{from.title}"}, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find_by(title: params[:title])
    end

    # Only allow a trusted parameter "white list" through.
    def note_params
      params.require(:note).permit(:title, :new_title, :content, :from, :to, :path)
    end
end


