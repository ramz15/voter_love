class VotableModel < ActiveRecord::Base
  acts_as_votable
end

class VoterModel < ActiveRecord::Base
  acts_as_voter
end  

class InvalidVotableModel < ActiveRecord::Base
  