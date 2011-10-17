ActiveRecord::Schema.define :version => 0 do
  create_table :votable_models, :force => true do |t|
    t.string :name
    t.integer :up_votes, :null => false, :default => 0
    t.integer :down_votes, :null => false, :default => 0
  end

  create_table :voter_models, :force => true do |t|
    t.string :name
    t.integer :up_votes, :null => false, :default => 0
    t.integer :down_votes, :null => false, :default => 0
  end

  create_table :invalid_votable_models, :force => true do |t|
    t.string :name
  end

  create_table :votes, :force => true do |t|
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