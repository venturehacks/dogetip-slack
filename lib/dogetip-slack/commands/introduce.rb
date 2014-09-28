module DogetipSlack
  module Commands
    # Introductions are necessary because of how Slack handles user mentions.
    #
    # In the Webhook, it replaces all user mentions w/ a slack ID, something similar to "UD13A4...". It also sends
    # the slack ID of the user generating the message. This ID stays consistent while usernames may change at
    # any moment without notice.
    #
    # In IRC, we only receive usernames. Without the permanent slack ID, we can't really do anything. So unless we
    # know how the username maps to the slack ID, we force an introduction.
    #
    # TODO: This seems succeptible to attack. I could "introduce" someone else with my username, then all tips to
    # that user would actually go to me, e.g. "dogetip introduce @brian joshuaxls".
    class Introduce < Base
      document 'introduce',
               usage: 'dogetip introduce [<username> <username_without_at>]',
               examples: ['dogetip introduce', 'dogetip introduce @someone someone'],
               description: 'Use in a public channel to teach the bot a new user.'

      def perform
        raise PublicCommand unless public?

        parts.none? ? self_introduction : third_party_introduction
      end

      private

      # Base#track_source_user does the work for us, so just return a response.
      def self_introduction
        "Hello #{user_link(source_user)}, very nice to meet you!"
      end

      def third_party_introduction
        user_id  = extract_slack_id(parts[0])
        username = parts[1]

        raise BadArgument.new('username') if user_id.nil?
        raise BadArgument.new('username_without_at') if username.nil? || username !~ /^[a-z0-9]+$/

        target_user = User.create slack_id: user_id, username: username
        "Hello #{user_link(target_user)}, very nice to meet you!"
      end
    end
  end
end