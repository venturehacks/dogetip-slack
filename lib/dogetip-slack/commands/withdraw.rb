module DogetipSlack
  module Commands
    class Withdraw < Base
      document 'withdraw',
        usage: 'withdraw <address> <amount>',
        examples: ['withdraw D8jv8iLcZSLv3uuzz1FGLySvEqVQVJ8d95 1000'],
        description: 'Withdraws the specified amount of DOGE from your account to the address given.'

      def perform
        txn = source_user.send_coins address, amount

        if public?
          "such banking #{user_link(source_user)} => #{address_link(address)} #{amount}Ð ($#{usd(amount)}) #{txn_link(txn)}"
        else
          "such banking #{user_link(source_user)} => #{address} #{amount}Ð ($#{usd(amount)}) #{txn_link_address(txn)}"
        end
      end

      private

      def address
        raise BadArgument.new('address') unless parts[0] =~ DOGE_ADDRESS_REGEX
        parts[0]
      end

      def amount
        raise BadArgument.new('amount') unless valid_amount?(parts[1])
        parts[1].to_i
      end
    end
  end
end