module DogetipSlack
  module Commands
    class Balance < Base
      document 'balance',
               description: 'Returns your current balance in DOGE and USD.'

      def perform
        "#{user_link(source_user)} such balance #{source_user.balance}Ð ($#{usd(source_user.balance)})"
      end
    end
  end
end