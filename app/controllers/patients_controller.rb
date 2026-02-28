class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  def index
    @patients = policy_scope(Patient)
      .search(params[:query])
      .ordered
      .includes(:tags)
      .page(params[:page])
  end

  def show
    authorize @patient
    @notes = @patient.notes.ordered.includes(:user)
    @upcoming_appointments = @patient.appointments.upcoming.includes(:user)
    @past_appointments = @patient.appointments.where.not(status: :scheduled).order(starts_at: :desc).limit(10).includes(:user)
    @activity_events = ActivityEvent.where(trackable: @patient).or(
      ActivityEvent.where(trackable: @patient.notes)
    ).or(
      ActivityEvent.where(trackable: @patient.appointments)
    ).order(created_at: :desc).limit(20).includes(:user)
  end

  def new
    @patient = Patient.new
    authorize @patient
  end

  def create
    @patient = Patient.new(patient_params)
    @patient.clinic = Current.clinic
    authorize @patient

    if @patient.save
      ActivityTracker.track(@patient, action: "created")
      redirect_to @patient, notice: "Patient created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @patient
  end

  def update
    authorize @patient
    if @patient.update(patient_params)
      ActivityTracker.track(@patient, action: "updated")
      redirect_to @patient, notice: "Patient updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @patient
    @patient.destroy
    redirect_to patients_path, notice: "Patient deleted."
  end

  private

  def set_patient
    @patient = Patient.find(params[:id])
  end

  def patient_params
    params.require(:patient).permit(:first_name, :last_name, :email, :phone, :date_of_birth, tag_ids: [])
  end
end
