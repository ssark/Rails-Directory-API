class FolderSerializer < ActiveModel::Serializer
  attributes :id, :title, :parent, :children
end
