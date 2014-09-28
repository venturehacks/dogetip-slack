module DogetipSlack
  module Commands
    class Network < Base
      document 'network',
               description: 'Returns debug information about the state of dogecoind.'

      def perform
        Dogecoin.getinfo.to_s
      end
    end
  end
end