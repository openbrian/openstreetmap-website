class CreateMicrocosms < ActiveRecord::Migration[5.2]
  def change
    create_table :microcosms do |t|
      t.string :name, :null => false
      t.string :key, :null => false
      t.string :facebook
      t.string :twitter
      t.text :description

      t.timestamps
    end
  end
end
