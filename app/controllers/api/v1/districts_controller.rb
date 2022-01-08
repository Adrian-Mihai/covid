module Api
  module V1
    class DistrictsController < ApplicationController
      def index
        country = Country.find_by!(code: params[:country_id])
        render json: country.districts.order(:name), status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { messages: ["Couldn't find #{e.model}"] }, status: :not_found
      end

      def show
        country = Country.find_by!(code: params[:country_id])
        district = country.districts.find_by!(code: params[:id])
        render json: district, additional_information: additional_information, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { messages: ["Couldn't find #{e.model}"] }, status: :not_found
      end
    end
  end
end
