class CreateUsersTable < ActiveRecord::Migration
  def change
  	create_table :users do |table|
	  	table.string :fname
	  	table.string :lname
	  	table.string :email
	  	table.string :user_name
	  	table.string :password
		end
	 	create_table :posts do |table|
	  	table.string :subject
	  	table.string :body
	  	table.integer :user_id
  		end
  	  	create_table :profiles do |table|
	  	table.string :info
	  	table.integer :user_id
	 	end
  	end
end
