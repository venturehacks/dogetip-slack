require 'cinch'

# This is a bit unwieldy. Should probably be refactored into a Cinch Plugin.
module DogetipSlack
  module Interfaces
    class IRC
      def self.run!
        raise "IRC_SERVER must be set!" if ENV['IRC_SERVER'].nil?
        raise "IRC_PASSWORD must be set!" if ENV['IRC_PASSWORD'].nil?

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
              command = command_klass.new username: message.user.name, parts: parts
              command.execute
            rescue DogeError => e
              e.message
            end

            if response.is_a?(Hash)
              bot.user_list.find_ensured(response[:to]).send(response[:message])
              if response[:reply]
                message.reply response[:reply]
              end
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