module DogetipSlack
  class User < ActiveRecord::Base
    def balance
      Dogecoin.getbalance slack_id
    end

    def send_coins(address, amount)
      check_available_balance! amount
      Dogecoin.sendfrom slack_id, address, amount
    end

    def receive_address
      Dogecoin.getnewaddress slack_id
    end

    private

    def check_available_balance!(amount)
      raise InsufficientFunds unless balance > amount + Dogecoin.tx_fee
    end
  end
end