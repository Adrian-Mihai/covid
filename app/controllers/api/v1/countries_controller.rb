module Api
  module V1
    class CountriesController < ApplicationController
      def index
        render json: Country.all, status: :ok
      end

      def show
        render json: Country.find(params[:id]), status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { messages: ["Couldn't find #{e.model}"] }, status: :not_found
      end
    end
  end
end
