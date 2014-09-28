require 'sinatra/base'
require 'sinatra/json'

module DogetipSlack
  module Interfaces
    class Webhook < Sinatra::Base
      def run!
        raise "SLACK_API_TOKEN must be set!" if ENV['SLACK_API_TOKEN'].nil?
        super
      end

      set :port, 4567

      post "/tip" do
        puts params
        next unless params['token'] == ENV['SLACK_API_TOKEN']

        parts   = params['text'].split[1..-1]
        command = parts.shift

        response = begin
          command_klass = Commands.find(command)
          command = command_klass.new username: params['user_name'], user_id: params['user_id'],
                                      parts: parts, channel: params['channel_name']
          command.execute
        rescue DogeError => e
          e.message
        end

        # Response should probably be its own object that just responds to #to_s, to keep this logic out,
        # which is only necessary for IRC direct responses.
        json text: response.is_a?(Hash) ? response[:reply] : response
      end
    end
  end
end