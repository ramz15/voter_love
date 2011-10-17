require 'voter_love/votes'
require 'voter_love/votable'
require 'voter_love/voter'
require 'voter_love/exceptions'

module VoterLove
  def votable?
    false
  end
  
  def voter?
    false
  end
  
  # add this to the model you want to be able to vote on.     
  # Example:
  # class Links < ActiveRecord::Base
  #   acts_as_votable
  # end
  def acts_as_votable 
    include Votable
  end
  
  def acts_as_voter
    include Voter
  end  
end

ActiveRecord::Base.extend VoterLove