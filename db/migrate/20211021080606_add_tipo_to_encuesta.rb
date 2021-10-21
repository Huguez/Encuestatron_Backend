class AddTipoToEncuesta < ActiveRecord::Migration[6.1]
    def change
        add_column :encuesta, :abierta, :boolean, :default => :false
    end
end
