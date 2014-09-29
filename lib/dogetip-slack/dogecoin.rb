require 'bitcoin-client'

module DogetipSlack
  DOGE_ADDRESS_REGEX = /^D{1}[5-9A-HJ-NP-U]{1}[1-9A-HJ-NP-Za-km-z]{32}$/
  class Dogecoin
    class << self
      def establish_connection
        raise "['dogecoind']['user'] must be set in config.yml!" if CONFIG['dogecoind']['user'].nil?
        raise "['dogecoind']['password'] must be set in config.yml!" if CONFIG['dogecoind']['password'].nil?

        @client = Bitcoin::Client.new CONFIG['dogecoind']['user'], CONFIG['dogecoind']['password'],
                                      host: '127.0.0.1', port: 22555, ssl: false
      end

      # Any way to get this from the API?
      def txn_fee
        1
      end

      def method_missing(method, *args, &block)
        @client.send method, *args, &block
      rescue NoMethodError
        super
      end
    end
  end
end