FactoryGirl.define do
  factory :user do
    name "Olly"
    email "olly@example.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
