module VoterLove
  class Vote < ActiveRecord::Base
    attr_accessible :votable, :voter, :up_vote
    
    belongs_to :votable, :polymorphic => true
    belongs_to :voter, :polymorphic => true
  end
end    