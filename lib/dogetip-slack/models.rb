require 'active_record'
require 'sqlite3'

module DogetipSlack
  autoload :TipTransaction, 'dogetip-slack/models/tip_transaction'
  autoload :Unit,           'dogetip-slack/models/unit'
  autoload :User,           'dogetip-slack/models/user'
end