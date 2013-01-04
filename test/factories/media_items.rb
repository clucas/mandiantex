# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  sequence(:random_category) {|n| YAML.load_file("#{Rails.root}/config/markup.yml").keys[rand(YAML.load_file("#{Rails.root}/config/markup.yml").keys.size)] }
  factory :media_item do
    title Faker::Name.title
    author Faker::Name.name
    publisher Faker::Company.name
    published_on Date.today
    unit_cost 1
    category { generate(:random_category) }
    currency "USD"
  end
end
