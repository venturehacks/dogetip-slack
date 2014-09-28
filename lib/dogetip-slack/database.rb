require 'active_record'

# I'm guessing there's a better way to do this...
module DogetipSlack
  module Database
    def self.check_schema!
      db = ActiveRecord::Base.connection

      unless db.table_exists?('users')
        db.create_table :users do |t|
          t.string :slack_id
          t.string :username
          t.timestamps
        end

        db.add_index :users, :slack_id
      end

      unless db.table_exists?('units')
        db.create_table :units do |t|
          t.string :name
          t.string :downcased_name
          t.float  :usd_value
          t.timestamps
        end

        db.add_index :units, :downcased_name
      end

      unless db.table_exists?('tip_transactions')
        db.create_table :tip_transactions do |t|
          t.integer :sender_id
          t.integer :recipient_id
          t.string :reason
          t.float :doge_amount
          t.float :usd_amount
          t.float :unit_amount
          t.belongs_to :unit
          t.string :txn_id
          t.string :channel
          t.timestamps
        end

        db.add_index :tip_transactions, :recipient_id
        db.add_index :tip_transactions, :sender_id
      end
    end
  end
end