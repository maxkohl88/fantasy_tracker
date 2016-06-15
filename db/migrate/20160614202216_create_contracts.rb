class CreateContracts < ActiveRecord::Migration[5.0]
  def change
    create_table :contracts do |t|
    	t.references :team
    	t.references :player

    	t.timestamps
    end
  end
end
