# encoding: utf-8
module DogetipSlack
  module Commands
    class Price < Base
      document 'price',
               description: 'Returns the current market price for 1,000Ð.'

      def perform
        "1000Ð = $#{usd(1000)} :rocket: :moon:"
      end
    end
  end
end