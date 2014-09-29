require 'dogetip-slack/commands'
require 'dogetip-slack/database'
require 'dogetip-slack/dogecoin'
require 'dogetip-slack/exceptions'
require 'dogetip-slack/inflections'
require 'dogetip-slack/interfaces'
require 'dogetip-slack/models'
require 'dogetip-slack/util'

module DogetipSlack
  class << self
    def setup_connections
      Dogecoin.establish_connection
      ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: File.join(DOGETIP_ROOT, 'doge.db')
      Database.check_schema!
    end

    def boot
      case ARGV[0]
        when 'irc'      then Interfaces::IRC.run!
        when 'webhook'  then Interfaces::Webhook.run!
        else raise "Please specify either 'webhook' or 'irc' on the command line"
      end
    end
  end
end

begin
  CONFIG = YAML::load_file File.join(DOGETIP_ROOT, 'config.yml')
rescue
  raise "Error loading config file: #{File.join(DOGETIP_ROOT, 'config.yml')}"
end

DogetipSlack.setup_connections