FactoryBot.define do
  factory :task do
    sequence(:title, "test_1")
    content { "テスト用のタスクです" }
    status { :todo }
    association :user
  end
end
