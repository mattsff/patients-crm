# ClinicCRM — White-Label Healthcare CRM SaaS

## Architecture Overview

- **Ruby 3.3** via rbenv, **Rails 7.2**, **PostgreSQL 14**
- **Hotwire** (Turbo + Stimulus), **Tailwind CSS**
- **Devise** (auth), **Pundit** (authorization), **Active Storage** (uploads)
- Multi-tenant: shared DB, scoped via `clinic_id` + `Current.clinic`

---

## Database Schema

```
clinics
  id, name, slug (unique), phone, email, address,
  primary_color, secondary_color, timezone,
  created_at, updated_at
  + Active Storage: logo

users
  id, clinic_id (FK), email, first_name, last_name,
  role (enum: owner/admin/staff),
  Devise columns (encrypted_password, reset_token, etc.),
  created_at, updated_at

patients
  id, clinic_id (FK), first_name, last_name,
  email, phone, date_of_birth,
  created_at, updated_at

appointments
  id, clinic_id (FK), patient_id (FK), user_id (FK),
  starts_at, ends_at,
  status (enum: scheduled/completed/canceled/no_show),
  notes (text),
  created_at, updated_at

notes
  id, clinic_id (FK), patient_id (FK), user_id (FK),
  content (text),
  created_at, updated_at

tags
  id, clinic_id (FK), name, color,
  created_at, updated_at

patient_tags
  patient_id (FK), tag_id (FK)
  (composite unique index)

activity_events
  id, clinic_id (FK), user_id (FK),
  trackable_type, trackable_id (polymorphic),
  action (string), metadata (jsonb),
  created_at
```

All tenant-scoped tables have `clinic_id` with an index.

---

## Implementation Phases

### Phase 1: Project Foundation
1. Install rbenv + Ruby 3.3
2. `rails new clinic_crm --database=postgresql --css=tailwind --skip-jbuilder`
3. Create all migrations (clinics, users, patients, appointments, notes, tags, patient_tags, activity_events)
4. Models with validations, associations, enums
5. Multi-tenant concern (`Tenantable`) — auto-scopes queries by `Current.clinic`
6. `Current` singleton to hold `Current.clinic` and `Current.user`

### Phase 2: Authentication & Tenant Resolution
1. Devise on User model (email/password, confirmable skipped for MVP)
2. Clinic registration flow: creates Clinic + Owner user in transaction
3. `SetCurrentTenant` controller concern — resolves clinic from `current_user.clinic`
4. Require authentication on all controllers (except registration/login)

### Phase 3: Authorization
1. Pundit setup with `ApplicationPolicy`
2. Policies: `ClinicPolicy`, `PatientPolicy`, `AppointmentPolicy`, `NotePolicy`
3. Role hierarchy: Owner > Admin > Staff
4. Staff: read/create patients & appointments; Admin: + manage users; Owner: + manage clinic settings

### Phase 4: Layout & White-Label
1. Application layout with sidebar navigation + top bar
2. Tailwind + CSS custom properties for theming (`--color-primary`, etc.)
3. `WhiteLabelHelper` — injects clinic colors/logo into layout
4. Clinic settings page: edit name, upload logo, pick primary color
5. Responsive sidebar (collapsible on mobile via Stimulus)

### Phase 5: Patient Management
1. Patients CRUD controller (scoped to clinic)
2. Index with search (by name/email/phone) via Turbo Frame
3. Show page: profile info + tabbed sections (notes, appointments, timeline)
4. Tags: manage + assign via Stimulus multi-select
5. Notes on patient: inline create/edit via Turbo Streams
6. Activity timeline on patient show (Turbo Frame, lazy-loaded)

### Phase 6: Appointments
1. Appointments CRUD (linked to patient + staff)
2. Status workflow (scheduled → completed/canceled/no_show)
3. Day/week calendar view (Stimulus controller for navigation)
4. Appointment list view with filters (date, status, staff)
5. Quick-schedule from patient profile

### Phase 7: Dashboard
1. Dashboard controller with metric queries
2. Cards: total patients, today's appointments, upcoming appointments
3. Recent activity feed (last 20 activity_events) via Turbo Frame
4. Auto-refresh dashboard via Turbo Stream (periodic polling or ActionCable)

### Phase 8: Polish & Production Readiness
1. Seed data (demo clinic with sample patients/appointments)
2. Error pages (404, 500)
3. Flash messages with Turbo-compatible dismiss
4. Request specs for critical paths
5. Dockerfile + docker-compose for dev environment

---

## Folder Structure Highlights

```
app/
  controllers/
    concerns/
      set_current_tenant.rb
      authentication.rb
    registrations_controller.rb    # clinic signup
    dashboard_controller.rb
    patients_controller.rb
    appointments_controller.rb
    notes_controller.rb
    clinic_settings_controller.rb
    users_controller.rb            # staff management
  models/
    concerns/
      tenantable.rb                # default_scope + clinic validation
    current.rb                     # Current.clinic, Current.user
    clinic.rb
    user.rb
    patient.rb
    appointment.rb
    note.rb
    tag.rb
    activity_event.rb
  policies/                        # Pundit
    application_policy.rb
    clinic_policy.rb
    patient_policy.rb
    appointment_policy.rb
  views/
    layouts/
      application.html.erb         # sidebar + white-label
    shared/
      _sidebar.html.erb
      _flash.html.erb
      _topbar.html.erb
    dashboard/
    patients/
    appointments/
    clinic_settings/
  javascript/
    controllers/                   # Stimulus
      sidebar_controller.js
      calendar_controller.js
      color_picker_controller.js
      search_controller.js
  helpers/
    white_label_helper.rb
  services/
    clinic_registration_service.rb
    activity_tracker.rb
```

---

## MVP vs Future

**MVP (this implementation):**
- Clinic registration + login
- Patient CRUD with notes and tags
- Appointment scheduling with status management
- Basic calendar (day/week)
- Dashboard with metrics
- White-label (logo, name, color)
- Role-based access (owner/admin/staff)

**Future iterations:**
- Subdomain-per-clinic routing
- Email/SMS appointment reminders
- Billing & subscription (Stripe)
- Treatment plans / clinical records
- Multi-location support
- API for integrations
- Audit log
- Data export (CSV/PDF)
- Two-factor authentication
