class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
    	t.references :season
    	t.json :mapping, default: {}, null: false

    	t.timestamps
    end
  end
end
