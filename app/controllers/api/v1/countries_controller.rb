module Api
  module V1
    class CountriesController < ApplicationController
      def index
        render json: Country.all, status: :ok
      end

      def show
        country = Country.find_by!(code: params[:id])
        render json: country, additional_information: additional_information, status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { messages: ["Couldn't find #{e.model}"] }, status: :not_found
      end
    end
  end
end
