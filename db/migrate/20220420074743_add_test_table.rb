class AddTestTable < ActiveRecord::Migration[6.1]
  def change
    create_table :test do |t|
      t.string :name
      t.string :part_number

      t.timestamps
     end
  end
end
