require 'httparty'

module DogetipSlack
  module Util
    private

    def usd(amount)
      (usd_rate * amount).round(3)
    end

    def extract_slack_id(string)
      /<@(U.+)>/.match(string)[1] rescue nil
    end

    def txn_link_address(txn)
      "http://dogechain.info/tx/#{txn}"
    end

    def txn_link(txn)
      link_to 'very verify', txn_link_address(txn)
    end

    def address_link(address)
      link_to address, "http://dogechain.info/address/#{address}"
    end

    def link_to(name, link)
      "<#{link}|#{name}>"
    end

    def user_link(user)
      "<@#{user.slack_id}>"
    end

    def valid_amount?(amount)
      amount.present? && amount =~ /[1-9]+/
    end

    def usd_rate
      unless $usd_rate && ($last_usd_check + 60 * 10) > Time.now.to_i
        result = HTTParty.get('http://pubapi.cryptsy.com/api.php?method=singlemarketdata&marketid=182')
        $usd_rate = result['return']['markets']['DOGE']['lasttradeprice'].to_f
        $last_usd_check = Time.now.to_i
      end
      $usd_rate
    rescue
      0
    end
  end
end