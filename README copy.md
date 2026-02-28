# ClinicCRM

White-label Healthcare CRM SaaS built with Ruby on Rails. Multi-tenant platform for dental/medical clinics to manage patients, appointments, staff, and notes.

## Stack

- **Ruby 3.3.10** · **Rails 8.1.2** · **PostgreSQL 14**
- **Hotwire** (Turbo + Stimulus) · **Tailwind CSS v4**
- **Devise** (authentication) · **Pundit** (authorization) · **Active Storage** (logo uploads)

## Features

- **Multi-tenant** — shared database scoped by `clinic_id` via `Current.clinic`
- **Clinic registration** — creates Clinic + Owner account in a single transaction
- **Patient management** — CRUD with inline search (Turbo Frame), tags, and notes
- **Appointments** — day/week calendar, status workflow (scheduled → completed/canceled/no_show)
- **Notes** — inline create/edit per patient via Turbo Streams
- **Dashboard** — metrics (total patients, today's appointments) + recent activity feed
- **White-label** — logo upload, custom primary/secondary colors per clinic (CSS custom properties)
- **Role-based access** — Owner > Admin > Staff (enforced via Pundit policies)
- **Staff management** — invite staff members, assign roles

## Getting Started

### Prerequisites

- Ruby 3.3.10 (via rbenv)
- PostgreSQL 14+

### Setup

```bash
bundle install
bin/rails db:create db:migrate db:seed
```

### Running the server

```bash
bin/dev
```

The app will be available at `http://localhost:3000`.

### Seed credentials

| Role  | Email                       | Password      |
|-------|-----------------------------|---------------|
| Owner | owner@brightsmiles.com      | password123   |
| Admin | admin@brightsmiles.com      | password123   |
| Staff | staff@brightsmiles.com      | password123   |

## Database Schema

```
clinics         id, name, slug, phone, email, address, primary_color, secondary_color, timezone
users           id, clinic_id, email, first_name, last_name, role (owner/admin/staff), Devise columns
patients        id, clinic_id, first_name, last_name, email, phone, date_of_birth
appointments    id, clinic_id, patient_id, user_id, starts_at, ends_at, status, notes
notes           id, clinic_id, patient_id, user_id, content
tags            id, clinic_id, name, color
patient_tags    patient_id, tag_id
activity_events id, clinic_id, user_id, trackable (polymorphic), action, metadata (jsonb)
```

## Project Structure

```
app/
├── controllers/
│   ├── concerns/set_current_tenant.rb   # resolves Current.clinic from current_user
│   ├── users/registrations_controller.rb
│   ├── dashboard_controller.rb
│   ├── patients_controller.rb
│   ├── appointments_controller.rb
│   ├── patient_appointments_controller.rb
│   ├── notes_controller.rb
│   ├── tags_controller.rb
│   ├── staff_controller.rb
│   └── clinic_settings_controller.rb
├── models/
│   ├── concerns/tenantable.rb           # default_scope + clinic_id enforcement
│   ├── current.rb
│   ├── clinic.rb · user.rb · patient.rb
│   └── appointment.rb · note.rb · tag.rb · activity_event.rb
├── policies/                            # Pundit
│   ├── application_policy.rb
│   ├── patient_policy.rb · appointment_policy.rb
│   ├── note_policy.rb · tag_policy.rb
│   └── staff_policy.rb · clinic_policy.rb
├── views/
│   ├── layouts/application.html.erb
│   ├── shared/_sidebar.html.erb · _topbar.html.erb · _flash.html.erb
│   └── dashboard/ · patients/ · appointments/ · notes/ · tags/ · staff/ · clinic_settings/
├── javascript/controllers/
│   ├── calendar_controller.js           # day/week navigation
│   ├── search_controller.js             # debounced patient search
│   ├── color_picker_controller.js       # white-label color picker
│   └── sidebar_controller.js
├── helpers/white_label_helper.rb
└── services/
    ├── clinic_registration_service.rb
    └── activity_tracker.rb
```

## Deployment

Docker-ready (see `Dockerfile`) and configured for [Kamal](https://kamal-deploy.org/) (see `.kamal/`).

```bash
kamal deploy
```

## Future Roadmap

- Subdomain-per-clinic routing
- Email/SMS appointment reminders
- Billing & subscriptions (Stripe)
- Treatment plans / clinical records
- Multi-location support
- REST API for integrations
- Data export (CSV/PDF)
- Two-factor authentication
