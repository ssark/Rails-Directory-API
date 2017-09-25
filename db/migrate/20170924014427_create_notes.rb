class CreateNotes < ActiveRecord::Migration[5.1]
  def change
    create_table :notes do |t|
      t.references :folder, null: false
      t.string :title
      t.string :content

      t.timestamps
    end
  end
end
