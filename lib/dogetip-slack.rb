require 'dogetip-slack/adapters'
require 'dogetip-slack/commands'
require 'dogetip-slack/database'
require 'dogetip-slack/dogecoin'
require 'dogetip-slack/exceptions'
require 'dogetip-slack/models'
require 'dogetip-slack/util'

module DogetipSlack
  class << self
    def boot
      Dogecoin.establish_connection
      ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: File.join(DOGETIP_ROOT, 'doge.db')
      Database.check_schema!

      case ARGV[0]
        when 'irc'      then Adapters::IRC.run!
        when 'webhook'  then Adapters::Webhook.run!
        else raise "Please specify either 'webhook' or 'irc' on the command line"
      end
    end
  end
end