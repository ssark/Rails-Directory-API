class WelcomeController < ApplicationController

  def all_data
    render json: {
      folders: Folder.all,
      notes: Note.all
    }
  end
end
