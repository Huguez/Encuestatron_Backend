class CreateEncuesta < ActiveRecord::Migration[6.1]
  def change
    create_table :encuesta do |t|
      t.string :titulo
      t.string :descripcion
      t.text :opciones, array: true
      t.boolean :activo
      t.integer :id_user_creator
      t.timestamps
    end
  end
end
