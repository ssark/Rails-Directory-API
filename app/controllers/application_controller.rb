class ApplicationController < ActionController::API
  include ActionController::Serialization

  def path?(path)
    return false if path.blank?

    folder_titles = path.split('/').to_a
    return false if folder_titles.empty?

    # getting rid of empty string at beginning of array
    folder_titles.shift

    curr = nil

    folder_titles.each do |s|
      if s.equal?(folder_titles.first) && curr.nil?
        curr = Folder.find_by(title: s)
        return false if curr.nil?
      else
        child = Folder.find_by(title: s)
        return false if child.nil?
        return false unless curr.children.include?(child) && child.parent == curr
        curr = child
      end
    end
    true
  end

  def get_target(path)
    path.split('/').to_a.last
  end
end
