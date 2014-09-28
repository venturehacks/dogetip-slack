module DogetipSlack
  module Commands
    class Deposit < Base
      document 'deposit',
               description: 'Returns a dogecoin address with which you can deposit more coins into your account. Each
                             call will return a new address. Old addresses can be reused forever.'

      def perform
        "send many coins to #{source_user.receive_address}"
      end
    end
  end
end