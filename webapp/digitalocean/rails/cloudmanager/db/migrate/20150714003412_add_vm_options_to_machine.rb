class AddVmOptionsToMachine < ActiveRecord::Migration
  def change
	  add_column :machines, :region, :string
	  add_column :machines, :size, :string
	  add_column :machines, :image, :string
	  add_column :machines, :backups, :boolean
	  add_column :machines, :ipv6, :boolean
	  add_column :machines, :private_networking, :boolean
  end
end
