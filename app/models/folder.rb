class Folder < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  belongs_to :parent, class_name: 'Folder', foreign_key: :folder_id, optional: :true
  has_many :children, class_name: 'Folder', dependent: :destroy
  has_many :notes, dependent: :destroy

  # returns the path of the folder
  def path
    return '/' if self.parent.nil?
    curr = self.parent
    path = ""
    while !curr.parent.nil? do
      path.prepend("/#{curr.title}")
      curr = curr.parent
    end
    path.prepend("/#{curr.title}")
    path
  end

  def as_json(options={})
    super(:only => [:title], :methods => [:path])
  end
end
