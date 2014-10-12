module DogetipSlack
  class Unit < ActiveRecord::Base
    # Properties:
    #
    # "id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL
    # "name" varchar(255)
    # "downcased_name" varchar(255)
    # "usd_value" float
    # "created_at" datetime NOT NULL
    # "updated_at" datetime NOT NULL

    before_create :downcase_name!

    private

    def downcase_name!
      self.downcased_name = name.downcase
    end
  end
end