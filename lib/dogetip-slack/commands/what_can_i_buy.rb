module DogetipSlack
  module Commands
    class WhatCanIBuy < Base
      document 'whatcanibuy',
               usage: 'whatcanibuy',
               description: 'Tells you all the wonderful stuff you could buy with your dogecoins.'

      def perform
        # Get the user's balance in USD
        user_balance = usd(source_user.balance)

        # Create a list of all the items that the user can purchase
        amount_left = user_balance
        to_buy = Unit.all.sort_by(&:usd_value).reverse.map do |unit|
          num_units = (amount_left / unit.usd_value).floor
          amount_left -= num_units * unit.usd_value
          [num_units, unit]
        end.select { |num, unit| num > 0 }

        if to_buy.count > 0
          sentence = "much rich. so can buy. amaze:\n"

          to_buy.each do |num, unit|
            sentence += "\n * #{num} #{unit.name.pluralize(num)}" # Insufficiently detailed pluralization...
          end

          sentence
        else
          'no coins. no buy. very empathy.'
        end
      end
    end
  end
end