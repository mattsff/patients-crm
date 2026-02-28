class PatientAppointmentsController < ApplicationController
  def new
    @patient = Patient.find(params[:patient_id])
    @appointment = Appointment.new(
      patient: @patient,
      starts_at: Time.current.beginning_of_hour + 1.hour
    )
    @appointment.ends_at = @appointment.starts_at + 30.minutes
    authorize @appointment
    render "appointments/new"
  end

  def create
    @patient = Patient.find(params[:patient_id])
    @appointment = Appointment.new(appointment_params)
    @appointment.patient = @patient
    @appointment.clinic = Current.clinic
    authorize @appointment

    if @appointment.save
      ActivityTracker.track(@appointment, action: "created")
      redirect_to @patient, notice: "Appointment scheduled."
    else
      render "appointments/new", status: :unprocessable_entity
    end
  end

  private

  def appointment_params
    params.require(:appointment).permit(:user_id, :starts_at, :ends_at, :notes)
  end
end
