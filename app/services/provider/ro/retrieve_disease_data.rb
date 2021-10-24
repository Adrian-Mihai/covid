module Provider
  module Ro
    class RetrieveDiseaseData < Provider::Ro::Base
      PATH = '/json.php'.freeze

      def perform
        return self unless valid?

        data = retrieve_data
        return self if data.nil?

        country_data = retrieve_country_data_form(data[:covid_romania])
        districts_data = retrieve_district_data_from(data[:covid_romania])

        payload = @country.payload.deep_merge(disease: country_data)
        @country.update!(payload: payload)
        @country.districts.each do |district|
          district_payload = districts_data[district.code]
          next if district_payload.nil?

          payload = district.payload.deep_merge(disease: district_payload)
          district.update!(payload: payload)
        rescue ActiveRecord::RecordInvalid => e
          e.record.errors.full_messages.each { |msg| @errors << "#{e.record.class.name} - #{msg}" }
          next
        end

        self
      rescue ActiveRecord::RecordInvalid => e
        e.record.errors.full_messages.each { |msg| @errors << "#{e.record.class.name} - #{msg}" }
        self
      end

      private

      def url
        URL + PATH
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
