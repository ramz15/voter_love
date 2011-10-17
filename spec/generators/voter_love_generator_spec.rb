require 'spec_helper'
require 'action_controller'
require 'generator_spec/test_case'
require 'generators/voter_love/voter_love_generator'

describe VoterLoveGenerator do
  include GeneratorSpec::TestCase
  destination File.expand_path("/tmp", __FILE__)
  tests VoterLoveGenerator

  before do
    prepare_destination
    run_generator
  end

  specify do
    destination_root.should have_structure {
      directory "db" do
        directory "migrate" do
          migration "create_voter_love_tables" do
            contains "class CreateVoterLoveTables"
            contains "create_table :votes"
          end
        end
      end
    }
  end
end