module Api
  module V1
    class CountrySerializer < ActiveModel::Serializer
      attributes :code, :name, :population, :overview, :provider
      attribute :disease, if: :include_disease?
      attribute :vaccine, if: :include_vaccine?

      def disease
        object.payload['disease']
      end

      def vaccine
        object.payload['vaccine']
      end

      def provider
        "Provider::#{object.code.downcase.classify}::Base::URL".safe_constantize
      end

      def include_disease?
        additional_information = instance_options[:additional_information]
        return false if additional_information.nil?

        additional_information[:include_disease_information] == 'true'
      end

      def include_vaccine?
        additional_information = instance_options[:additional_information]
        return false if additional_information.nil?

        additional_information[:include_vaccine_information] == 'true'
      end
    end
  end
end
