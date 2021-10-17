class AddSegundaRondaToEncuesta < ActiveRecord::Migration[6.1]
  def change
    add_column :encuesta, :id_encuesta_prev, :integer, :default => :null
  end
end
