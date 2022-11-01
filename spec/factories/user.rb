FactoryBot.define do  
    factory :user do
        email { "Anything@gmail.com" }
        password { "Anything" }
        fullname { "vranda" }
        phone_number { "999999999" }
    end
end
