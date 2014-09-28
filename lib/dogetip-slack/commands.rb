module DogetipSlack
  module Commands
    @commands = {}

    class << self
      def add(command, info)
        @commands[command] = info
      end

      def docs(command)
        @commands[command]
      end

      def find(command)
        @commands[command][:klass]
      rescue NoMethodError
        raise CommandNotFound.new(command)
      end

      def list
        @commands.keys.sort
      end
    end
  end
end

require 'dogetip-slack/commands/base'

require 'dogetip-slack/commands/balance'
require 'dogetip-slack/commands/deposit'
require 'dogetip-slack/commands/help'
require 'dogetip-slack/commands/introduce'
#require 'dogetip-slack/commands/learn'
require 'dogetip-slack/commands/network'
require 'dogetip-slack/commands/price'
require 'dogetip-slack/commands/tip'
require 'dogetip-slack/commands/withdraw'
