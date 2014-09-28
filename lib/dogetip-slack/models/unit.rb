module DogetipSlack
  class Unit < ActiveRecord::Base
    before_create :downcase_name!

    private

    def downcase_name!
      self.downcased_name = name.downcase
    end
  end
end