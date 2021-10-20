module Api
  module V1
    class DistrictsController < ApplicationController
      def index
        country = Country.find(params[:country_id])
        render json: country.districts, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { messages: ["Couldn't find #{e.model}"] }, status: :not_found
      end

      def show
        country = Country.find(params[:country_id])
        render json: country.districts.find(params[:id]), status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { messages: ["Couldn't find #{e.model}"] }, status: :not_found
      end
    end
  end
end
