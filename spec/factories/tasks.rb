FactoryBot.define do
  factory :task do
    sequence(:title) { |n| "test#{n}" }
    content { "テスト用のタスクです"}
    status { 0 }
    association :user
  end
end
