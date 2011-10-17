class CreateVoterLoveTables < ActiveRecord::Migration
   def self.up
     create_table :votes do |t|
       t.string :votable_type
       t.integer :votable_id
       t.string :voter_type
       t.integer :voter_id
       t.boolean :up_vote, :null => false

       t.timestamps
    end

    add_index :votes, [:votable_type, :votable_id]
    add_index :votes, [:voter_type, :voter_id]
    add_index :votes, [:votable_type, :votable_id, :voter_type, :voter_id], :name => "unique_voters", :unique => true
  end

  def self.down
    remove_index :votes, :column => [:votable_type, :votable_id]
    remove_index :votes, :column => [:voter_type, :voter_id]
    remove_index :votes, :name => "unique_voters"
    
    drop_table :votes
  end
end