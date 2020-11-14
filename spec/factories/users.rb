FactoryBot.define do
  factory :user do
    email { "example@example.com" }
    password { "foobar" }
    password_confirmation { "foobar" }
  end
end
