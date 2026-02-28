class ClinicSettingsController < ApplicationController
  def show
    @clinic = Current.clinic
    authorize @clinic, :show?, policy_class: ClinicPolicy
  end

  def update
    @clinic = Current.clinic
    authorize @clinic, :update?, policy_class: ClinicPolicy

    if @clinic.update(clinic_params)
      redirect_to clinic_settings_path, notice: "Settings updated."
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def clinic_params
    params.require(:clinic).permit(:name, :phone, :email, :address, :primary_color, :secondary_color, :timezone, :logo)
  end
end
