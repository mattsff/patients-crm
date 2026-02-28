class StaffController < ApplicationController
  def index
    @staff = policy_scope(Current.clinic.users, policy_scope_class: StaffPolicy::Scope).order(:last_name, :first_name)
  end

  def new
    @user = User.new
    authorize @user, :create?, policy_class: StaffPolicy
  end

  def create
    @user = Current.clinic.users.build(staff_params)
    @user.password = SecureRandom.hex(8)
    authorize @user, :create?, policy_class: StaffPolicy

    if @user.save
      redirect_to staff_index_path, notice: "Staff member added. They can reset their password via email."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @user = Current.clinic.users.find(params[:id])
    authorize @user, :destroy?, policy_class: StaffPolicy
    @user.destroy
    redirect_to staff_index_path, notice: "Staff member removed."
  end
end
