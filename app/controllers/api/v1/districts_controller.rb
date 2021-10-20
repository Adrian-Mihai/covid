module Api
  module V1
    class DistrictsController < ApplicationController
      def index
        render json: District.all, status: :ok
      end

      def show
        render json: District.find(params[:id]), status: :ok
      rescue ActiveRecord::RecordNotFound => e
        render json: { messages: ["Couldn't find #{e.model}"] }, status: :not_found
      end
    end
  end
end
