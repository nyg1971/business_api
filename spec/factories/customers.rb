# frozen_string_literal: true

FactoryBot.define do
  factory :customer do
    name { 'MyString' }
    customer_type { 1 }
    department { nil }
  end
end
