require 'active_record'

module DogetipSlack
  module Database
    def self.check_schema!
      db = ActiveRecord::Base.connection

      db.create_table :users do |t|
        t.string :slack_id
        t.string :username
        t.timestamps
      end unless db.table_exists?('users')

      db.create_table :units do |t|
        t.string :denomination
        t.float  :usd_value
        t.timestamps
      end unless db.table_exists?('units')
    end
  end
end