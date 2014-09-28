require 'bitcoin-client'

module DogetipSlack
  DOGE_ADDRESS_REGEX = /^D{1}[5-9A-HJ-NP-U]{1}[1-9A-HJ-NP-Za-km-z]{32}$/
  class Dogecoin
    class << self
      def establish_connection
        @client = Bitcoin::Client.new ENV["DOGECOIN_USER"], ENV["DOGECOIN_PASSWORD"],
                                      host: '127.0.0.1', port: 22555, ssl: false
      end

      # Any way to get this from the API?
      def tx_fee
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