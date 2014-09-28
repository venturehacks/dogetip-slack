module DogetipSlack
  module Commands
    class Tip < Base
      document 'tip',
               usage: 'tip <username> <amount> [<denomination>] [for <reason>]',
               examples: ['tip @someone 100', 'tip @someone 2 beers', 'tip @someone 100 for being awesome'],
               description: 'Sends a tip to the target user.'

      def perform
        tx = source_user.send_coins target_user.receive_address, doge_amount

        message = "#{user_link(source_user)} => #{user_link(target_user)} #{doge_amount}Ð " +
          "($#{usd(doge_amount)}) wow #{tx_link(tx)}"

        {to: target_user.username, message: message}
      end

      private

      def doge_amount
        raise BadArgument.new("amount") unless valid_amount?(parts[1])
        amount = parts[1].to_i

        #type = @params.shift
        #unit    = Unit.search(parts[2..-1])
        #amount  =
        #if type
        #  begin
        #    usd_value = @db.execute "SELECT usd_value FROM conversions WHERE name = ?", type.singularize
        #    puts usd_value[0][0], @amount, usd_rate
        #    @amount = (@amount * usd_value[0][0] / usd_rate).to_i
        #  rescue # Conversion not in DB, assume amount is DOGE
        #  end
        #end

        # Validations. Perhaps this should go elsewhere?
        raise DogeError.new("scrooge mcshibe, 10 doge minimum!") if amount < 10

        amount
      end
      memoize :doge_amount

      def target_user
        if extract_slack_id(parts[0])
          # Slack API style, ID given instead of user_name
          User.find_or_create_by_slack_id(extract_slack_id(parts[0]))
        elsif parts[0] =~ /@(\w+)/
          # IRC style, must find the ID
          User.find_by_username($1) or raise UnknownUser.new($1)
        else
          raise BadArgument.new("username")
        end
      end
      memoize :target_user
    end
  end
end