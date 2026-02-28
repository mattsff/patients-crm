class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]

  def new
    build_resource({})
    @clinic = Clinic.new
    respond_with resource
  end

  def create
    result = ClinicRegistrationService.call(
      clinic_params: clinic_params,
      user_params: sign_up_params
    )

    if result.success?
      sign_in(result.user)
      set_flash_message! :notice, :signed_up
      redirect_to root_path
    else
      build_resource(sign_up_params)
      @clinic = Clinic.new(clinic_params)
      resource.errors.merge!(result.errors) if result.errors
      render :new, status: :unprocessable_entity
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

  private

  def clinic_params
    params.require(:clinic).permit(:name)
  end
end
