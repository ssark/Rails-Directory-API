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

  # POST /notes
  def create
    folder = Folder.find_by(title: params[:folder])
    return render json: { message: "Folder doesn't exist #{params[:folder]}"}, status: :unprocessable_entity if folder.nil?

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
    from = Folder.find_by(title: params[:from])
    to = Folder.find_by(title: params[:to])

    return render json: {error: "Folder #{params[:from]} doesn't exist"}, status: :unprocessable_entity if from.nil?
    return render json: {error: "Folder #{params[:to]} doesn't exist"}, status: :unprocessable_entity if to.nil?

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
      params.require(:note).permit(:title, :new_title, :content, :folder, :from, :to)
    end
end
