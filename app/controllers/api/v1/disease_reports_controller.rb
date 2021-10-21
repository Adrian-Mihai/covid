module Api
  module V1
    class DiseaseReportsController < ApplicationController
      def index
        country = Country.find(params[:country_id])
        render json: country.disease_reports, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { messages: ["Couldn't find #{e.model}"] }, status: :not_found
      end
    end
  end
end
