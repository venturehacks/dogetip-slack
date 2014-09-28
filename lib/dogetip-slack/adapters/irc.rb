require 'cinch'

# This is a bit unwieldy. Should probably be refactored into a Cinch Plugin.
module DogetipSlack
  module Adapters
    class IRC
      def self.run!
        bot = Cinch::Bot.new do

          configure do |c|
            c.server      = ENV['IRC_SERVER']
            c.password    = ENV['IRC_PASSWORD']
            c.nick        = 'doge'
            c.delay_joins = 10

            c.ssl.use     = true
            c.ssl.verify  = false
          end

          on :private do |message|
            next unless message.user

            parts   = message.message.split
            command = parts.shift

            response = begin
              command_klass = Commands.find(command)
              command = command_klass.new username: message.user.name, parts: parts, private: true
              command.execute
            rescue DogeError => e
              e.message
            end

            if response.is_a?(Hash)
              bot.user_list.find_ensured(response[:to]).send(response[:message])
            else
              message.reply response
            end
          end
        end

        bot.start
      end
    end
  end
end