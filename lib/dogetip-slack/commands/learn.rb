module DogetipSlack
  module Commands
    class Learn < Base
      document 'learn',
               usage: 'learn <some item> <price_in_usd>',
               examples: ['learn beer $4', 'learn bottle of water $1.25'],
               description: 'Teaches the bot a new denomination to tip with.'
    end
  end
end

#def learn
#  item  = @params.shift
#  value = @params.shift
#
#  puts item, value
#
#  raise "value must be in USD" unless value =~ /^\$\d*\.?\d+/
#
#  @db.execute "DELETE FROM conversions WHERE name = ?", item
#  @db.execute "INSERT INTO conversions VALUES (?, ?)", item, value[1..-1]
#  @result[:text] = "okay, one #{item} = #{value}"
#end