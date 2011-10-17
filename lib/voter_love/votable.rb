module VoterLove
  module Votable
    extend ActiveSupport::Concern

    included do
      has_many :votes, :class_name => "VoterLove::Votes", :as => :votable
    end

    module ClassMethods
      def votable?
        true
      end
    end

    # Returns the difference of down and up votes.
    def score
      self.up_votes - self.down_votes
    end
  end
end