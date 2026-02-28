class ClinicRegistrationService
  Result = Struct.new(:success?, :clinic, :user, :errors, keyword_init: true)

  def self.call(clinic_params:, user_params:)
    new(clinic_params: clinic_params, user_params: user_params).call
  end

  def initialize(clinic_params:, user_params:)
    @clinic_params = clinic_params
    @user_params = user_params
  end

  def call
    ActiveRecord::Base.transaction do
      clinic = Clinic.create!(@clinic_params)
      user = clinic.users.create!(
        **@user_params,
        role: :owner
      )

      Result.new(success?: true, clinic: clinic, user: user)
    end
  rescue ActiveRecord::RecordInvalid => e
    Result.new(success?: false, errors: e.record.errors)
  end
end
