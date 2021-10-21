module Api
  module V1
    class DistrictReportsController < ApplicationController
      def index
        country = Country.find(params[:country_id])
        district = country.districts.find(params[:district_id])
        render json: district.district_reports, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { messages: ["Couldn't find #{e.model}"] }, status: :not_found
      end
    end
  end
end
