FactoryBot.define do
  factory :task do
    sequence(:title, "test_1")
    content { "テスト用のタスクです"}
    status { 0 }
    association :user
  end
end
