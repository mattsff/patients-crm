class DashboardController < ApplicationController
  def show
    authorize :dashboard, :show?
    @total_patients = Patient.count
    @appointments_today = Appointment.today.count
    @upcoming_appointments = Appointment.upcoming.limit(5).includes(:patient, :user)
    @recent_activity = ActivityEvent.recent.includes(:user, :trackable)
  end
end
