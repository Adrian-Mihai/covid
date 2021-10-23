class ApplicationController < ActionController::API
  def version
    version = File.read('VERSION').strip
    render json: { version: version }, status: :ok
  end

  private

  def additional_information
    {
      include_disease_information: params[:include_disease_information],
      include_vaccine_information: params[:include_vaccine_information]
    }
  end
end
