module VoterLove
  module Exceptions
    class AlreadyVotedError < StandardError
      attr_reader :up_vote

      def initialize(up_vote)
        vote = if up_vote
          "up voted"
        else
          "down voted"
        end

        super "The votable was already #{vote} by the voter."
      end
    end

    class NotVotedError < StandardError
      def initialize
        super "The votable was not voted by the voter."
      end
    end

    class InvalidVotableError < StandardError
      def initialize
        super "Invalid votable."
      end
    end
  end
end
