FactoryBot.define do  
   factory :event do
        association :admin_user
        event_name { "XYZ" }
        description { "Anythinggggg" }
        event_date { DateTime.now }
        price { 100.00 }
    end
  end
  