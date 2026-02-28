class AppointmentsController < ApplicationController
  before_action :set_appointment, only: [:show, :edit, :update, :destroy, :complete, :cancel, :no_show]

  def index
    @view = params[:view] || "week"
    @date = params[:date] ? Date.parse(params[:date]) : Date.current

    base = policy_scope(Appointment).includes(:patient, :user)
    @appointments = case @view
    when "day"
      base.for_date(@date).ordered
    else
      base.for_week(@date).ordered
    end
  end

  def show
    authorize @appointment
  end

  def new
    @appointment = Appointment.new(
      starts_at: params[:starts_at] || Time.current.beginning_of_hour + 1.hour,
      patient_id: params[:patient_id]
    )
    @appointment.ends_at = @appointment.starts_at + 30.minutes if @appointment.starts_at
    authorize @appointment
  end

  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.clinic = Current.clinic
    authorize @appointment

    if @appointment.save
      ActivityTracker.track(@appointment, action: "created")
      redirect_to appointments_path, notice: "Appointment scheduled."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @appointment
  end

  def update
    authorize @appointment
    if @appointment.update(appointment_params)
      ActivityTracker.track(@appointment, action: "updated")
      redirect_to appointments_path, notice: "Appointment updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @appointment
    @appointment.destroy
    redirect_to appointments_path, notice: "Appointment deleted."
  end

  def complete
    authorize @appointment
    @appointment.update!(status: :completed)
    ActivityTracker.track(@appointment, action: "status_changed", metadata: { from: "scheduled", to: "completed" })
    redirect_back(fallback_location: appointments_path, notice: "Appointment marked as completed.")
  end

  def cancel
    authorize @appointment
    @appointment.update!(status: :canceled)
    ActivityTracker.track(@appointment, action: "status_changed", metadata: { from: "scheduled", to: "canceled" })
    redirect_back(fallback_location: appointments_path, notice: "Appointment canceled.")
  end

  def no_show
    authorize @appointment
    @appointment.update!(status: :no_show)
    ActivityTracker.track(@appointment, action: "status_changed", metadata: { from: "scheduled", to: "no_show" })
    redirect_back(fallback_location: appointments_path, notice: "Appointment marked as no-show.")
  end

  private

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:patient_id, :user_id, :starts_at, :ends_at, :status, :notes)
  end
end
