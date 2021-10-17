class AddSegundaRondaFromEncuesta < ActiveRecord::Migration[6.1]
  def change
    add_column :encuesta, :segunda_ronda, :boolean, :default => false
  end
end
