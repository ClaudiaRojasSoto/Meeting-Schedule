FactoryBot.define do
  factory :meeting do
    title { "Reunión Vida y Ministerio Cristianos" }
    date { Date.today + 7.days }
    location { "Salón del Reino" }
    notes { "Reunión semanal regular" }
    meeting_type { "Entre Semana" }
  end
end
