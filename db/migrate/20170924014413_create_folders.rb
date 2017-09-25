class CreateFolders < ActiveRecord::Migration[5.1]
  def change
    create_table :folders do |t|
      t.string :title
      t.references :folder
      t.timestamps
    end
  end
end
