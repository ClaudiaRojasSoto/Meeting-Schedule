puts "Creando usuario administrador..."
admin = User.create!(
  email: "admin@example.com",
  password: "password123",
  password_confirmation: "password123",
  role: "admin",
  name: "Administrador"
)
puts "✓ Admin creado: #{admin.email}"

puts "\nCreando usuario miembro..."
member = User.create!(
  email: "member@example.com",
  password: "password123",
  password_confirmation: "password123",
  role: "member",
  name: "Juan Pérez"
)
puts "✓ Miembro creado: #{member.email}"

puts "\nCreando reunión de ejemplo..."
meeting = Meeting.create!(
  title: "Reunión Vida y Ministerio Cristianos",
  date: Date.today + 7.days,
  location: "Salón del Reino",
  meeting_type: "Entre Semana",
  notes: "Reunión semanal regular"
)
puts "✓ Reunión creada: #{meeting.title}"

puts "\nCreando items de agenda..."
items = [
  { start_time: Time.parse("19:00"), duration_minutes: 5, role: "Presidente", speaker: "Juan Pérez", position: 1 },
  { start_time: Time.parse("19:05"), duration_minutes: 10, role: "Lectura de la Biblia", speaker: "Pedro González", position: 2 },
  { start_time: Time.parse("19:15"), duration_minutes: 15, role: "Primera conversación", speaker: "María López", position: 3 },
  { start_time: Time.parse("19:30"), duration_minutes: 15, role: "Revisita", speaker: "Ana Martínez", position: 4 }
]

items.each do |item_data|
  meeting.schedule_items.create!(item_data)
  puts "✓ Item creado: #{item_data[:role]}"
end

puts "\n✅ Seeds completados!"
puts "\nCredenciales de acceso:"
puts "Admin: admin@example.com / password123"
puts "Miembro: member@example.com / password123"
