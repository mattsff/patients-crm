puts "Seeding database..."

# Create demo clinic
clinic = Clinic.find_or_create_by!(slug: "bright-smiles") do |c|
  c.name = "Bright Smiles Dental"
  c.email = "info@brightsmiles.com"
  c.phone = "(555) 123-4567"
  c.address = "123 Main Street, Suite 100\nAnytown, CA 90210"
  c.primary_color = "#4F46E5"
  c.secondary_color = "#818CF8"
  c.timezone = "Pacific Time (US & Canada)"
end

# Set current tenant for seeding
Current.clinic = clinic

# Create users
owner = User.find_or_create_by!(email: "owner@brightsmiles.com") do |u|
  u.clinic = clinic
  u.first_name = "Sarah"
  u.last_name = "Johnson"
  u.role = :owner
  u.password = "password123"
  u.password_confirmation = "password123"
end

admin = User.find_or_create_by!(email: "admin@brightsmiles.com") do |u|
  u.clinic = clinic
  u.first_name = "Michael"
  u.last_name = "Chen"
  u.role = :admin
  u.password = "password123"
  u.password_confirmation = "password123"
end

staff = User.find_or_create_by!(email: "staff@brightsmiles.com") do |u|
  u.clinic = clinic
  u.first_name = "Emily"
  u.last_name = "Rodriguez"
  u.role = :staff
  u.password = "password123"
  u.password_confirmation = "password123"
end

Current.user = owner

# Create tags
tags = {}
[
  { name: "VIP", color: "#EF4444" },
  { name: "New Patient", color: "#3B82F6" },
  { name: "Insurance", color: "#10B981" },
  { name: "Pediatric", color: "#F59E0B" },
  { name: "Orthodontics", color: "#8B5CF6" }
].each do |tag_attrs|
  tags[tag_attrs[:name]] = Tag.find_or_create_by!(name: tag_attrs[:name], clinic: clinic) do |t|
    t.color = tag_attrs[:color]
  end
end

# Create patients
patients_data = [
  { first_name: "James", last_name: "Wilson", email: "james.wilson@email.com", phone: "(555) 234-5678", date_of_birth: "1985-03-15", tags: ["VIP", "Insurance"] },
  { first_name: "Maria", last_name: "Garcia", email: "maria.garcia@email.com", phone: "(555) 345-6789", date_of_birth: "1992-07-22", tags: ["New Patient"] },
  { first_name: "Robert", last_name: "Smith", email: "robert.smith@email.com", phone: "(555) 456-7890", date_of_birth: "1978-11-08", tags: ["Insurance"] },
  { first_name: "Lisa", last_name: "Anderson", email: "lisa.anderson@email.com", phone: "(555) 567-8901", date_of_birth: "2001-01-30", tags: ["Orthodontics"] },
  { first_name: "David", last_name: "Brown", email: "david.brown@email.com", phone: "(555) 678-9012", date_of_birth: "1965-09-12", tags: ["VIP", "Insurance"] },
  { first_name: "Sophie", last_name: "Taylor", email: "sophie.taylor@email.com", phone: "(555) 789-0123", date_of_birth: "2015-05-20", tags: ["Pediatric"] },
  { first_name: "Thomas", last_name: "Martinez", email: "thomas.martinez@email.com", phone: "(555) 890-1234", date_of_birth: "1990-12-03", tags: ["New Patient"] },
  { first_name: "Jennifer", last_name: "Lee", email: "jennifer.lee@email.com", phone: "(555) 901-2345", date_of_birth: "1988-06-17", tags: ["Insurance", "Orthodontics"] },
]

patients = patients_data.map do |pd|
  patient_tags = pd.delete(:tags)
  patient = Patient.find_or_create_by!(email: pd[:email], clinic: clinic) do |p|
    p.assign_attributes(pd)
  end
  patient.tags = patient_tags.map { |name| tags[name] }
  patient
end

# Create appointments
staff_members = [owner, admin, staff]
statuses = [:scheduled, :completed, :canceled, :no_show]

# Past appointments
patients.each_with_index do |patient, i|
  2.times do |j|
    date = (30 - (i * 3) - j * 7).days.ago.change(hour: 9 + (i % 6), min: [0, 30].sample)
    Appointment.find_or_create_by!(
      clinic: clinic,
      patient: patient,
      starts_at: date
    ) do |a|
      a.user = staff_members.sample
      a.ends_at = date + 30.minutes
      a.status = [:completed, :completed, :no_show].sample
    end
  end
end

# Future appointments
patients.first(5).each_with_index do |patient, i|
  date = (i + 1).days.from_now.change(hour: 10 + i, min: 0)
  Appointment.find_or_create_by!(
    clinic: clinic,
    patient: patient,
    starts_at: date
  ) do |a|
    a.user = staff_members.sample
    a.ends_at = date + 30.minutes
    a.status = :scheduled
  end
end

# Today's appointments
3.times do |i|
  date = Date.current.change(hour: 9 + (i * 2), min: 0)
  next if date < Time.current

  Appointment.find_or_create_by!(
    clinic: clinic,
    patient: patients[i],
    starts_at: date
  ) do |a|
    a.user = staff_members[i % 3]
    a.ends_at = date + 45.minutes
    a.status = :scheduled
  end
end

# Create notes
patients.first(5).each do |patient|
  Note.find_or_create_by!(patient: patient, user: owner, clinic: clinic, content: "Initial consultation completed. Patient in good health.") do |n|
    n.created_at = 2.weeks.ago
  end
  Note.find_or_create_by!(patient: patient, user: admin, clinic: clinic, content: "Follow-up scheduled. No concerns.") do |n|
    n.created_at = 1.week.ago
  end
end

# Create activity events for recent items
Patient.last(3).each do |patient|
  ActivityEvent.find_or_create_by!(
    clinic: clinic,
    user: owner,
    trackable: patient,
    action: "created"
  )
end

Appointment.last(3).each do |appointment|
  ActivityEvent.find_or_create_by!(
    clinic: clinic,
    user: appointment.user,
    trackable: appointment,
    action: "created"
  )
end

puts "Seeding complete!"
puts ""
puts "Login credentials:"
puts "  Owner: owner@brightsmiles.com / password123"
puts "  Admin: admin@brightsmiles.com / password123"
puts "  Staff: staff@brightsmiles.com / password123"
