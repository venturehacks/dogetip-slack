# encoding: utf-8
#
require 'bitcoin-client'
require './bitcoin_client_extensions.rb'
require 'httparty'
require 'sqlite3'
require 'active_support/core_ext/string/inflections'

class Command
  attr_accessor :result, :action, :user_name
  ACTIONS = %w(balance info deposit tip withdraw networkinfo learn)
  def initialize(slack_params)
    text = slack_params['text']
    @params = text.split(/\s+/)
    raise "WACK" unless @params.shift == slack_params['trigger_word']
    @user_name = slack_params['user_name']
    @user_id = slack_params['user_id']
    @action = @params.shift
    @result = {}
    @db = SQLite3::Database.new File.join(File.dirname(__FILE__), "doge.db")
  end

  def perform
    if ACTIONS.include?(@action)
      self.send("#{@action}".to_sym)
    else
      raise "such error no command wow"
    end
  end

  def learn
    item  = @params.shift 
    value = @params.shift

    puts item, value

    raise "value must be in USD" unless value =~ /^\$\d*\.?\d+/

    @db.execute "DELETE FROM conversions WHERE name = ?", item
    @db.execute "INSERT INTO conversions VALUES (?, ?)", item, value[1..-1]
    @result[:text] = "okay, one #{item} = #{value}"
  end

  def client
    @client ||= Bitcoin::Client.local('dogecoin')
  end

  def balance
    balance = client.getbalance(@user_id)
    @result[:text] = "@#{@user_name} such balance #{balance}Ð ($#{usd(balance)})"
    if (balance > 0)
      @result[:text] += " many coin"
    elsif balance > 1000
      @result[:text] += " very wealth!"
    end

  end

  def deposit
    @result[:text] = "so deposit #{user_address(@user_id)} many address"
  end

  def tip
    user = @params.shift
    raise "pls say tip @username amount" unless user =~ /<@(U.+)>/

    target_user = $1
    set_amount

    tx = client.sendfrom @user_id, user_address(target_user), @amount
    @result[:text] = "<@#{@user_id}> => <@#{target_user}> #{@amount}Ð ($#{usd(@amount)}) wow"
    @result[:text] += " (<http://dogechain.info/tx/#{tx}|very verify>)"
  end

  alias :":dogecoin:" :tip

  def withdraw
    address = @params.shift
    set_amount
    tx = client.sendfrom @user_id, address, @amount
    @result[:text] = "such stingy <@#{@user_id}> => #{address} #{@amount}Ð (#{tx})"
  end

  def networkinfo
    info = client.getinfo
    @result[:text] = info.to_s
  end

  private

  def usd(amount)
    (usd_rate * amount).round(3)
  end 

  def usd_rate
    unless @usd_rate && (@last_usd_check + 60 * 10) > Time.now.to_i
      @usd_rate = HTTParty.get('http://pubapi.cryptsy.com/api.php?method=singlemarketdata&marketid=182')['return']['markets']['DOGE']['lasttradeprice'].to_f
      @last_usd_check = Time.now.to_i
    end
    @usd_rate
  rescue
    0
  end

  def set_amount
    @amount = @params.shift
    randomize_amount if (@amount == "random")
    @amount = @amount.to_i

    type = @params.shift
    if type
      begin
        usd_value = @db.execute "SELECT usd_value FROM conversions WHERE name = ?", type.singularize
        puts usd_value[0][0], @amount, usd_rate
        @amount = (@amount * usd_value[0][0] / usd_rate).to_i
      rescue # Conversion not in DB, assume ammount is DOGE
      end 
    end
    
    raise "very poor, such balance: #{available_balance}Ð" unless available_balance >= @amount.to_i + 1
    raise "wow. 10 doge minimum" if @amount < 10
  end

  def randomize_amount
    lower = [1, @params.shift.to_i].min
    upper = [@params.shift.to_i, available_balance].max
    @amount = rand(lower..upper)
  end

  def available_balance
     client.getbalance(@user_id)
  end

  def user_address(user_id)
     existing = client.getaddressesbyaccount(user_id)
    if (existing.size > 0)
      @address = existing.first
    else
      @address = client.getnewaddress(user_id)
    end
  end
end
