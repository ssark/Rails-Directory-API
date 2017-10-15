class NotesController < ApplicationController
  before_action :set_note, only: [:show, :update, :move]

  def show
    return render json: { error: 'Note does not exist' } if @note.nil?
    render json: @note.as_json
  end

  def create
    return render json: { error: 'No path specified' }, status: :bad_request if params[:path].blank?
    return render json: { error: 'Path does not exist'}, status: :bad_request unless path?(params[:path])

    folder = Folder.find_by(title: get_target(params[:path]))
    return render json: { message: 'Target folder doesn\'t exist' }, status: :bad_request if folder.nil?

    @note = Note.new(title: params[:title], content: params[:content], folder_id: folder.id)

    if @note.save
      render json: @note.as_json, status: :created, location: @note
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  def update
    if !params[:new_title].blank? && !params[:content].blank?
      update_params = { title: params[:new_title], content: params[:content]}
    elsif !params[:new_title].blank?
      update_params = { title: params[:new_title] }
    else
      update_params = { content: params[:content] }
    end

    if @note.update(update_params)
      render json: @note.as_json
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  def move
    return render json: { error: 'No from path provided' }, status: :bad_request if params[:from].blank?
    return render json: {error: 'No to path provided'}, status: :bad_request if params[:to].blank?

    return render json: { error: "Note #{params[:title]} doesn't exist" }, status: :bad_request if @note.nil?

    from = Folder.find_by(title: get_target(params[:from])) if path?(params[:from])
    to = Folder.find_by(title: get_target(params[:to])) if path?(params[:to])

    return render json: { error: 'From path doesn\'t exist' }, status: :bad_request if from.nil?
    return render json: { error: 'To path doesn\'t exist' }, status: :bad_request if to.nil?

    if from.notes.include?(@note) && @note.folder == from
      @note.update(folder_id: to.id)
      render json: @note.as_json
    else
      render json: { error: "Note #{@note.title} can't be found in folder #{from.title}" }, status: :unprocessable_entity
    end
  end

  private

  def set_note
    @note = Note.find_by(title: params[:title])
  end

  def note_params
    params.require(:note).permit(:title, :new_title, :content, :from, :to, :path)
  end
end
