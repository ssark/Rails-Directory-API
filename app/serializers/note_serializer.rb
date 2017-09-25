class NoteSerializer < ActiveModel::Serializer
  attributes :title, :content, :folder
end
