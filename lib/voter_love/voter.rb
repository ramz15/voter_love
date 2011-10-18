module VoterLove
  module Voter
    extend ActiveSupport::Concern
    
    included do
      has_many :votes, :class_name => "VoterLove::Vote", :as => :voter
    end
    
    module ClassMethods
      def voter? 
        true
      end
    end
    
    # Up vote any "votable" object.
    # Raises an AlreadyVotedError if the voter already voted on the object.
    def up_vote(votable)
      is_votable?(votable)
      
      vote = get_vote(votable)
      
      if vote
        if vote.up_vote
          raise Exceptions::AlreadyVotedError.new(true)
        end
          vote.up_vote = true
          votable.down_votes -= 1
          self.down_votes -= 1 if has_attribute?(:down_votes)
        end
      else
        vote = Vote.create(:votable => votable, :voter => self, :up_vote => true)
      end
      
      votable.up_votes += 1
      self.up_votes += 1 if has_attribute?(:up_votes)  
      
      Vote.transaction do
        save
        votable.save
        vote.save
      end
      
      true
    end        
      
    # Up vote any "votable" object without raising an error. Vote is ignored.
    def up_vote!(votable)
      begin
        up_vote(votable)
        success = true
      rescue Exceptions::AlreadyVotedError
        success = false
      end
      success
    end
    
    # Down vote a "votable" object.      
    # Raises an AlreadyVotedError if the voter already voted on the object.
    def down_vote(votable)
      is_votable?(votable)
      
      vote = get_vote(votable)
      
      if vote
        unless vote.up_vote
          raise Exceptions::AlreadyVotedError.new(false)
        else
          vote.up_vote = false
          votable.up_votes -= 1
          self.up_votes -= 1 if has_attribute?(:up_votes)
        end
      else
        vote = Vote.create(:votable => votable, :voter => self, :up_vote => false)     
      end
      
      votable.down_votes += 1
      self.down_votes += 1 if has_attribute?(:down_votes)
      
      Vote.transaction do
        save
        votable.save
        vote.save
      end
      
      true
    end    
    
    # Down vote a "votable" object without raising an error. Vote is ignored.
    def down_vote!(votable)
      begin
        down_vote(votable)
        success = true
      rescue Exceptions::AlreadyVotedError
        success = false
      end
      success
    end
    
    # Returns true if the voter voted for the "votable".
    def voted?(votable)
      is_votable?(votable)
      vote = get_vote(votable)
      !vote.nil?
    end  
    
    # Returns true if the voter up voted the "votable".
    def up_voted?(votable)
      is_votable?(votable)
      vote = get_vote(votable)
      return false if vote.nil?
      return true if vote.has_attribute?(:up_vote) && vote.up_vote
      false
    end    
    
    # Returns true if the voter down voted the "votable".
    def down_voted?(votable)
      is_votable?(votable)
      vote = get_vote(votable)
      return false if vote.nil?
      return true if vote.has_attribute?(:up_vote) && !vote.up_vote
      false
    end
    
    private
    
      def get_vote(votable)
        Vote.where(
          :votable_type => votable.class.to_s,
          :votable_id => votable.id,
          :voter_type => self.class.to_s,
          :voter_id => self.id).try(:first)
      end  
    
      def is_votable?(votable)
        raise Exceptions::InvalidVotableError unless votable.class.votable?
      end          
  end
end    