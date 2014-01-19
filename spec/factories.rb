FactoryGirl.define do
  factory :user do
    email    "email@example.com"
    password "foobarqwe"
    password_confirmation "foobarqwe"
  end

  factory :feedback do
    title "Lorem Ipsumss"
    user
  end

  factory :comment do
    content "test titel"
    feedback
  end
end
