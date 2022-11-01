require 'rails_helper'

RSpec.describe Event, :type => :model do

    subject { create(:event) }

    context "testing associations" do
        it "belongs to a AdminUser" do
          expect { subject.admin_user }.to_not raise_error
        end
      end

    context "testing validations" do
        it "is not valid without a admin_user_id" do
          subject.admin_user_id = nil
          expect(subject).to_not be_valid
        end
    end

end
