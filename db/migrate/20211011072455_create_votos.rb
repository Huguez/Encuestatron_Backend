class CreateVotos < ActiveRecord::Migration[6.1]
  def change
    create_table :votos do |t|
      t.string :opcion
      t.integer  :id_votante
      t.integer :id_encuesta

      t.timestamps
    end
  end
end
