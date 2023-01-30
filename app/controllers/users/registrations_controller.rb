# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with(resource, _options = {})
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Yay, you were signed up successfully', data: resource }
      }, status: :ok
    else
      render json: { message: 'Oops, could not able to signed up successfully !!!', errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
