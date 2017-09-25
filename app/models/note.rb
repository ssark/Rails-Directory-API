class Note < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  belongs_to :folder

  def path
    curr = folder
    path = ""
    while !curr.parent.nil? do
      path.prepend("/#{curr.title}")
      curr = curr.parent
    end
    path.prepend("/#{curr.title}")
    path
  end

  def as_json(options={})
    super(:only => [:title, :content],
      :methods => [:path],
    )
  end

end


