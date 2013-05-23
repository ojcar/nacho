class RegistrationsController < Devise::RegistrationsController

  def create
    redirect_to root_path if Rails.env.production?
  end

end