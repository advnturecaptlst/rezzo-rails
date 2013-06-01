class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.attachment :photo

      t.timestamps
    end
  end
end
