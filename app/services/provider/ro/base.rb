module Provider
  module Ro
    class Base
      attr_reader :errors

      URL = 'https://www.graphs.ro'.freeze

      def initialize(code:)
        @errors = []
        @country = Country.find_by!(code: code)
      rescue ActiveRecord::RecordNotFound => e
        @errors << "Couldn't find #{e.model}"
      end

      def valid?
        @errors.empty?
      end

      def perform
        raise NotImplementedError, 'Implement in subclass'
      end

      protected

      def retrieve_data
        response = Faraday.get(url)
        unless response.success?
          @errors << "Provider respond with status #{response.status} and body #{response.body}"
          return nil
        end

        JSON.parse(response.body, symbolize_names: true)
      rescue Faraday::ClientError, Faraday::ServerError, JSON::ParserError => e
        @errors << e.message
        nil
      end

      def url
        raise NotImplementedError, 'Implement in subclass'
      end
    end
  end
end
