require 'dogetip-slack/util'
require 'memoist'

module DogetipSlack
  module Commands
    class Base
      include Util
      extend Memoist

      attr_reader :username, :user_id, :parts, :private

      def self.document(command, info_hash)
        Commands.add command, info_hash.merge(klass: self)
      end

      def initialize(params)
        @username = params[:username]
        @user_id  = params[:user_id]
        @parts    = params[:parts]
        @private  = params[:private]
      end

      def execute
        store_source_user
        perform
      rescue Exception => e
        if e.is_a?(DogeError)
          raise e
        else
          raise CommandError.new(e)
        end
      ensure
        ActiveRecord::Base.connection.close
      end

      private

      def private?
        !!self.private
      end

      def public?
        !self.private
      end

      # If we see a new user using the bot, let's make sure they're in the DB.
      def store_source_user
        if source_user
          #source_user.store_username(username)
        elsif user_id && username
          User.create slack_id: user_id, username: username
          flush_cache
        else
          raise UnknownUser
        end
      end

      def source_user
        if user_id
          User.find_by_slack_id user_id
        elsif username
          User.find_by_username username
        end
      end
      memoize :source_user
    end
  end
end