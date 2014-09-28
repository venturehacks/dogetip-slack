module DogetipSlack
  module Commands
    class Learn < Base
      document 'learn',
               usage: 'learn <some_singular_item> <price_in_usd>',
               examples: ['learn beer $4', 'learn slice of pizza $1.25'],
               description: 'Teaches the bot a new denomination to tip with.'

      NAME_RANGE  = 0..-2
      USD_INDEX   = -1
      def perform
        name = parts[NAME_RANGE].join(' ')

        raise BadArgument.new('some_singular_item') unless name.present?
        raise BadArgument.new("price_in_usd") unless parts[USD_INDEX] =~ /^\$\d*\.?\d+/

        unit = Unit.find_or_create_by_name name
        unit.update_attribute :usd_value, parts[USD_INDEX][1..-1]

        "wow, one #{unit.name} = $#{unit.usd_value}"
      end
    end
  end
end