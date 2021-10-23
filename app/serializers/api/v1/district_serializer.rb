module Api
  module V1
    class DistrictSerializer < ActiveModel::Serializer
      attributes :code, :name, :population
      attribute :disease, if: :include_disease?

      def disease
        object.payload['disease']
      end

      def include_disease?
        additional_information = instance_options[:additional_information]
        return false if additional_information.nil?

        additional_information[:include_disease_information] == 'true'
      end
    end
  end
end
