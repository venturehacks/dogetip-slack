require 'sinatra/base'
require 'sinatra/json'

raise "Please set SLACK_API_TOKEN" if ENV['SLACK_API_TOKEN'].nil?

module DogetipSlack
  module Adapters
    class Webhook < Sinatra::Base
      set :port, 4567

      post "/tip" do
        puts params
        next unless params['token'] == ENV['SLACK_API_TOKEN']

        parts   = params['text'].split[1..-1]
        command = parts.shift

        response = begin
          command_klass = Commands.find(command)
          command = command_klass.new username: params['user_name'], user_id: params['user_id'],
                                      parts: parts, private: false
          command.execute
        rescue DogeError => e
          e.message
        end

        # Response should probably be its own object that just responds to #to_s, to keep this logic out,
        # which is only necessary for IRC direct responses.
        json text: response.is_a?(Hash) ? response[:message] : response
      end
    end
  end
end