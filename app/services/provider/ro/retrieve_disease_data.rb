module Provider
  module Ro
    class RetrieveDiseaseData
      URL = 'https://www.graphs.ro/json.php'.freeze

      attr_reader :errors

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
        return self unless valid?

        data = retrieve_data
        return self if data.nil?

        data[:covid_romania].each do |daily_report|
          next if @country.disease_reports.exists?(date: daily_report[:reporting_date])

          @country.disease_reports.create!(map_disease_report_data(daily_report))
          save_data_for_districts(daily_report[:county_data], daily_report[:reporting_date])
        rescue ActiveRecord::RecordInvalid => e
          e.record.errors.full_messages.each { |msg| @errors << "#{e.record.class.name} - #{msg}" }
          next
        end

        self
      end

      private

      def retrieve_data
        response = Faraday.get(URL)
        unless response.success?
          @errors << "Provider respond with status #{response.status} and body #{response.body}"
          return nil
        end

        JSON.parse(response.body, symbolize_names: true)
      rescue Faraday::ClientError, Faraday::ServerError, JSON::ParserError => e
        @errors << e.message
        nil
      end
      
      def map_disease_report_data(daily_report)
        {
          date: daily_report[:reporting_date],
          cases: daily_report[:new_cases_today],
          tests: daily_report[:new_tests_today],
          deaths: daily_report[:new_deaths_today],
          recovered: daily_report[:new_recovered_today],
          intensive_care: daily_report[:intensive_care_right_now],
          hospitalized: daily_report[:infected_hospitalized],
          emergency_calls: daily_report[:emergency_calls],
          information_calls: daily_report[:information_calls],
          home_isolation: daily_report[:persons_in_home_isolation],
          home_quarantine: daily_report[:persons_in_home_quarantine],
          institutional_isolation: daily_report[:persons_in_institutional_isolation],
          institutional_quarantine: daily_report[:persons_in_institutional_quarantine]
        }
      end

      def save_data_for_districts(data, date)
        return if data.nil?

        data.each do |district|
          d = @country.districts.find_by!(code: district[:county_id])
          next if d.district_reports.exists?(date: date)

          d.district_reports.create!(date: date, cases: district[:total_cases])
        rescue ActiveRecord::RecordNotFound => e
          @errors << "Couldn't find #{e.model}"
          next
        rescue ActiveRecord::RecordInvalid => e
          e.record.errors.full_messages.each { |msg| @errors << "#{e.record.class.name} - #{msg}" }
          next
        end
      end
    end
  end
end
