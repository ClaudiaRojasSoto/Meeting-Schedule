FactoryBot.define do
  factory :schedule_item do
    association :meeting
    start_time { Time.parse("19:00") }
    duration_minutes { 15 }
    role { "Presidente" }
    speaker { Faker::Name.name }
    notes { "Observaciones adicionales" }
    position { 1 }
  end
end
