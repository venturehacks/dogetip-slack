module DogetipSlack
  module Commands
    class Tip < Base
      document 'tip',
               usage: 'tip <username> <amount> [<unit>] [for <reason>]',
               examples: ['tip @someone 100', 'tip @someone 2 beers', 'tip @someone 100 for being awesome'],
               description: 'Sends a tip to the target user.'

      attr_accessor :txn_id, :original_amount

      def perform
        self.txn_id = source_user.send_coins target_user.receive_address, doge_amount
        record_transaction!

        {to: target_user.username, message: message, reply: reply}
      end

      private

      # What's sent privately to the receiving user, if this is a private tip.
      def message
        [reply, reason.present? ? "for #{reason}" : nil].compact.join("\n")
      end

      # What's sent publicly (in a channel), or sent privately to the sending user.
      def reply
        string = ["#{user_link(source_user)} => #{user_link(target_user)}"]
        string << "#{doge_amount}Ð"
        string << "(#{original_amount} #{unit.name.pluralize(original_amount)})" unless unit.nil?
        string << "wow"
        string << (public? ? txn_link(txn_id) : txn_link_address(txn_id))
        string.join ' '
      end
      memoize :reply

      def reason
        if parts.index('for') && parts.length > parts.index('for')
          parts[parts.index('for') + 1..-1].join " "
        end
      end
      memoize :reason

      AMOUNT_INDEX = 1
      def doge_amount
        raise BadArgument.new("amount") unless valid_amount?(parts[AMOUNT_INDEX])
        self.original_amount = parts[AMOUNT_INDEX].to_i
        amount = if unit
          (original_amount * unit.usd_value / usd_rate).to_i
        else
          original_amount
        end

        # Validations. Perhaps this should go elsewhere?
        raise DogeError.new("scrooge mcshibe, 10 doge minimum!") if amount < 10

        amount
      end
      memoize :doge_amount

      # Keep walking everything between the amount and the reason (beginning with "for") until we
      # find a unit that's in the DB. Should this move into Models::Unit?
      UNIT_INDEX = 2
      def unit
        max = parts.index('for') || parts.length - 1
        return nil if max < UNIT_INDEX

        UNIT_INDEX.upto(max) do |step|
          name_parts = parts[UNIT_INDEX..step]

          # Handle special cases of "slices of pizza", "bottles of wine", etc.
          possible_name = if name_parts[0].singularize != name_parts[0] && name_parts[1] == 'of'
            name_parts[0].singularize + " #{name_parts[1..-1].join(' ')}"
          else
            name_parts.join(' ').singularize.downcase
          end

          return nil if possible_name == 'doge'
          possible_unit = Unit.find_by_downcased_name(possible_name)
          return possible_unit if possible_unit
        end

        raise BadArgument.new('unit')
      end
      memoize :unit

      TARGET_INDEX = 0
      def target_user
        target_user = if extract_slack_id(parts[TARGET_INDEX])
          # Slack API style, ID given instead of user_name
          User.find_or_create_by_slack_id(extract_slack_id(parts[TARGET_INDEX]))
        elsif parts[TARGET_INDEX] =~ /@(\w+)/
          # IRC style, must find the ID
          User.find_by_username($1) or raise UnknownUser.new($1)
        else
          raise BadArgument.new('username')
        end

        raise DogeError.new("such pointless. wow.") if target_user.slack_id == 'SLACKBOT'
        target_user
      end
      memoize :target_user

      def record_transaction!
        tip = source_user.outgoing_tips.create recipient_id: target_user.id
        tip.doge_amount = doge_amount
        tip.usd_amount  = usd(doge_amount)
        tip.channel     = channel
        tip.reason      = reason
        tip.txn_id      = txn_id

        if unit
          tip.unit        = unit
          tip.unit_amount = original_amount
        end

        tip.save
      end
    end
  end
end
