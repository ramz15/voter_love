require 'rails/generators/migration'
require 'rails/generators/active_record'

class VoterLoveGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  desc "Generates a migration for the Votes model"

  def self.source_root
    @source_root ||= File.dirname(__FILE__) + '/templates'
  end

  def self.next_migration_number(path)
    ActiveRecord::Generators::Base.next_migration_number(path)
  end

  def generate_migration
    migration_template 'migration.rb', 'db/migrate/create_voter_love_tables'
  end
end
