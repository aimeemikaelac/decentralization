class CreateMachines < ActiveRecord::Migration
  def change
    create_table :machines do |t|
      t.string :name
      t.string :instancename
      t.string :account
      t.references :type, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :machines, :instancename, unique: true
  end
end
