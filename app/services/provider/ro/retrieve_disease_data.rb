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

        country_data = retrieve_country_data_form(data[:covid_romania])
        districts_data = retrieve_district_data_from(data[:covid_romania])

        @country.update!(payload: { disease: country_data })
        @country.districts.each do |district|
          payload = districts_data[district.code]
          next if payload.nil?

          district.update!(payload: { disease: payload })
        rescue ActiveRecord::RecordInvalid => e
          e.record.errors.full_messages.each { |msg| @errors << "#{e.record.class.name} - #{msg}" }
        end
        self
      rescue ActiveRecord::RecordInvalid => e
        e.record.errors.full_messages.each { |msg| @errors << "#{e.record.class.name} - #{msg}" }
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

      def retrieve_country_data_form(disease_report)
        disease_report.map { |report| map_disease_report_data(report) }.reverse
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

      def retrieve_district_data_from(disease_report)
        districts = @country.districts.pluck(:code).map { |code| [code, []] }.to_h
        county_data = disease_report.pluck(:reporting_date, :county_data).map do |date, district_data|
          district_data&.map do |hash|
            hash[:date] = date
            hash
          end
        end
        county_data.compact.each do |daily_report|
          daily_report.each do |county_report|
            districts[county_report[:county_id]] << { date: county_report[:date], cases: county_report[:total_cases] }
          end
        end
        districts.transform_values!(&:reverse)
        districts.each do |county, reports|
          aux = []
          reports.each_with_index do |report, index|
            next if index.zero?

            tmp = { date: report[:date], cases: nil }
            cases = report[:cases] - reports[index - 1][:cases]
            tmp[:cases] = cases >= 0 ? cases : 0
            aux << tmp
          end
          districts[county] = aux
        end
        districts
      end
    end
  end
end
