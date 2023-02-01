class ApplicationController < ActionController::API
  rescue_from StandardError do |e|
    if e.message.include?('Error occurred while parsing request parameters')
      render json: { error: 'Please provide required information properly to create a company' }, status: 400
    elsif e.message.include?("Couldn't find")
      render json: { error: "No record exists with given ID = #{params[:id]}" }, status: 404
    else
      e.message.include?('You are not authorized to access this page.')
      render json: { error: 'You are not authorized to access this page.' }, status: 401
    end
  end
end
