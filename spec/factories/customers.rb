FactoryBot.define do
  factory :customer do
    first_name { Faker::Name.name }
    last_name { Faker::Name.name }
  end
end
