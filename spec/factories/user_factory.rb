FactoryBot.define do
  factory :user, class: User do
    email { "janusz@o2.pl" }
    name { "Janusz" }
    password { "123456" }
    admin { false }
  end
end
