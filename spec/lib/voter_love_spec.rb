require File.expand_path('../../spec_helper', __FILE__)

describe "Voter Love" do
  before(:each) do
    @votable = VotableModel.create(:name => "Votable 1")
    @voter = VoterModel.create(:name => "Voter 1")
  end

  it "should create a votable instance" do
    @votable.class.should == VotableModel
    @votable.class.votable?.should == true
  end

  it "should create a voter instance" do
    @voter.class.should == VoterModel
    @voter.class.voter?.should == true
  end

  it "should get correct vote summary" do
    @voter.up_vote(@votable).should == true
    @votable.votes.should == 1
    @voter.down_vote(@votable).should == true
    @votable.votes.should == -1
    @voter.unvote(@votable).should == true
    @votable.votes.should == 0
  end

  it "votable should have up vote votes" do
    @votable.votes.length.should == 0
    @voter.up_vote(@votable)
    @votable.votes.reload.length.should == 1
    @votable.votes[0].up_vote?.should be_true
  end

  it "voter should have up vote votes" do
    @voter.votes.length.should == 0
    @voter.up_vote(@votable)
    @voter.votes.reload.length.should == 1
    @voter.votes[0].up_vote?.should be_true
  end

  it "votable should have down vote votes" do
    @votable.votes.length.should == 0
    @voter.down_vote(@votable)
    @votable.votes.reload.length.should == 1
    @votable.votes[0].up_vote?.should be_false
  end

  it "voter should have down vote votes" do
    @voter.votes.length.should == 0
    @voter.down_vote(@votable)
    @voter.votes.reload.length.should == 1
    @voter.votes[0].up_vote?.should be_false
  end

  describe "up vote" do
    it "should increase up votes of votable by one" do
      @votable.up_votes.should == 0
      @voter.up_vote(@votable)
      @votable.up_votes.should == 1
    end

    it "should increase up votes of voter by one" do
      @voter.up_votes.should == 0
      @voter.up_vote(@votable)
      @voter.up_votes.should == 1
    end

    it "should create a voting" do
      VoterLove::Votes.count.should == 0
      @voter.up_vote(@votable)
      VoterLove::Votes.count.should == 1
      voting = VoterLove::Votes.first
      voting.votable.should == @votable
      voting.voter.should == @voter
      voting.up_vote.should == true
    end

    it "should only allow a voter to up vote a votable once" do
      @voter.up_vote(@votable)
      lambda { @voter.up_vote(@votable) }.should raise_error(VoterLove::Exceptions::AlreadyVotedError)
    end

    it "should only allow a voter to up vote a votable once without raising an error" do
      @voter.up_vote!(@votable)
      lambda {
        @voter.up_vote!(@votable).should == false
      }.should_not raise_error(VoterLove::Exceptions::AlreadyVotedError)
      VoterLove::Votes.count.should == 1
    end

    it "should change a down vote to an up vote" do
      @voter.down_vote(@votable)
      @votable.up_votes.should == 0
      @votable.down_votes.should == 1
      @voter.up_votes.should == 0
      @voter.down_votes.should == 1
      VoterLove::Votes.count.should == 1
      VoterLove::Votes.first.up_vote.should be_false
      @voter.up_vote(@votable)
      @votable.up_votes.should == 1
      @votable.down_votes.should == 0
      @voter.up_votes.should == 1
      @voter.down_votes.should == 0
      VoterLove::Votes.count.should == 1
      VoterLove::Votes.first.up_vote.should be_true
    end

    it "should allow up votes from different voters" do
      @voter2 = VoterModel.create(:name => "Voter 2")
      @voter.up_vote(@votable)
      @voter2.up_vote(@votable)
      @votable.up_votes.should == 2
      VoterLove::Votes.count.should == 2
    end

    it "should raise an error for an invalid votable" do
      invalid_votable = InvalidVotableModel.create
      lambda { @voter.up_vote(invalid_votable) }.should raise_error(VoterLove::Exceptions::InvalidVotableError)
    end

    it "should check if voter up voted votable" do
      @voter.up_vote(@votable)
      @voter.voted?(@votable).should be_true
      @voter.up_voted?(@votable).should be_true
      @voter.down_voted?(@votable).should be_false
    end
  end

  describe "vote down" do
    it "should decrease down votes of votable by one" do
      @votable.down_votes.should == 0
      @voter.down_vote(@votable)
      @votable.down_votes.should == 1
    end

    it "should decrease down votes of voter by one" do
      @voter.down_votes.should == 0
      @voter.down_vote(@votable)
      @voter.down_votes.should == 1
    end

    it "should create a voting" do
      VoterLove::Votes.count.should == 0
      @voter.down_vote(@votable)
      VoterLove::Votes.count.should == 1
      voting = VoterLove::Votes.first
      voting.votable.should == @votable
      voting.voter.should == @voter
      voting.up_vote.should == false
    end

    it "should only allow a voter to down vote a votable once" do
      @voter.down_vote(@votable)
      lambda { @voter.down_vote(@votable) }.should raise_error(VoterLove::Exceptions::AlreadyVotedError)
    end

    it "should only allow a voter to down vote a votable once without raising an error" do
      @voter.down_vote!(@votable)
      lambda {
        @voter.down_vote!(@votable).should == false
      }.should_not raise_error(VoterLove::Exceptions::AlreadyVotedError)
      VoterLove::Votes.count.should == 1
    end

    it "should change an up vote to a down vote" do
      @voter.up_vote(@votable)
      @votable.up_votes.should == 1
      @votable.down_votes.should == 0
      @voter.up_votes.should == 1
      @voter.down_votes.should == 0
      VoterLove::Votes.count.should == 1
      VoterLove::Votes.first.up_vote.should be_true
      @voter.down_vote(@votable)
      @votable.up_votes.should == 0
      @votable.down_votes.should == 1
      @voter.up_votes.should == 0
      @voter.down_votes.should == 1
      VoterLove::Votes.count.should == 1
      VoterLove::Votes.first.up_vote.should be_false
    end

    it "should allow down votes from different voters" do
      @voter2 = VoterModel.create(:name => "Voter 2")
      @voter.down_vote(@votable)
      @voter2.down_vote(@votable)
      @votable.down_votes.should == 2
      VoterLove::Votes.count.should == 2
    end

    it "should raise an error for an invalid votable" do
      invalid_votable = InvalidVotableModel.create
      lambda { @voter.down_vote(invalid_votable) }.should raise_error(VoterLove::Exceptions::InvalidVotableError)
    end

    it "should check if voter down voted votable" do
      @voter.down_vote(@votable)
      @voter.voted?(@votable).should be_true
      @voter.up_voted?(@votable).should be_false
      @voter.down_voted?(@votable).should be_true
    end
  end

  describe "unvote" do
    it "should decrease the up votes if up voted before" do
      @voter.up_vote(@votable)
      @votable.up_votes.should == 1
      @voter.up_votes.should == 1
      @voter.unvote(@votable)
      @votable.up_votes.should == 0
      @voter.up_votes.should == 0
    end

    it "should remove the voting" do
      @voter.up_vote(@votable)
      VoterLove::Votes.count.should == 1
      @voter.unvote(@votable)
      VoterLove::Votes.count.should == 0
    end

    it "should raise an error if voter didn't vote for the votable" do
      lambda { @voter.unvote(@votable) }.should raise_error(VoterLove::Exceptions::NotVotedError)
    end

    it "should not raise error if voter didn't vote for the votable and unvote! is called" do
      lambda {
        @voter.unvote!(@votable).should == false
      }.should_not raise_error(VoterLove::Exceptions::NotVotedError)
    end

    it "should raise an error for an invalid votable" do
      invalid_votable = InvalidVotableModel.create
      lambda { @voter.unvote(invalid_votable) }.should raise_error(VoterLove::Exceptions::InvalidVotableError)
    end
  end
end