module Provider
  module Ro
    class RetrieveVaccineData < Provider::Ro::Base
      PATH = '/vaccinare_json.php'.freeze

      def perform
        return self unless valid?

        data = retrieve_data
        return self if data.nil?

        update_vaccination_infos(data[:covid_romania_vaccination])
        update_vaccination_overview(data.dig(:covid_romania_vaccination, 0))

        self
      rescue ActiveRecord::RecordInvalid => e
        e.record.errors.full_messages.each { |msg| @errors << "#{e.record.class.name} - #{msg}" }
        self
      end

      private

      def url
        URL + PATH
      end

      def update_vaccination_infos(daily_reports)
        return if daily_reports.nil?

        country_data = retrieve_country_data_form(daily_reports)
        payload = @country.payload.deep_merge(vaccine: country_data)
        @country.update!(payload: payload)
      rescue ActiveRecord::RecordInvalid => e
        e.record.errors.full_messages.each { |msg| @errors << "#{e.record.class.name} - #{msg}" }
      end

      def retrieve_country_data_form(vaccine_report)
        vaccine_report.map { |report| map_vaccine_report_data(report) }.reverse
      end

      def map_vaccine_report_data(daily_report)
        {
          date: daily_report[:data_date],
          vaccine: {
            pfizer: {
              dose: {
                '1': daily_report[:pfizer_1],
                '2': daily_report[:pfizer_2],
                '3': daily_report[:pfizer_3]
              },
              side_effects: daily_report[:PFIZER_ra_min_total_24]
            },
            moderna: {
              dose: {
                '1': daily_report[:moderna_1],
                '2': daily_report[:moderna_2],
                '3': daily_report[:moderna_3]
              },
              side_effects: daily_report[:MODERNA_ra_min_total_24]
            },
            astra_zeneca: {
              dose: {
                '1': daily_report[:astrazeneca_1],
                '2': daily_report[:astrazeneca_2],
                '3': daily_report[:astrazeneca_3]
              },
              side_effects: daily_report[:ASTRAZENECA_ra_min_total_24]
            },
            johnson: {
              dose: {
                '1': daily_report[:johnson_1]
              },
              side_effects: daily_report[:JOHNSON_ra_min_total_24]
            }
          }
        }
      end

      def update_vaccination_overview(report)
        return if report.nil?

        vaccinated = report[:total_2].to_i
        return if vaccinated.nil?

        payload = @country.payload['vaccine']
        vaccine = {
          period: {
            from: payload.first&.dig('date'),
            to: payload.last&.dig('date')
          },
          vaccinated: vaccinated
        }

        @country.update!(overview: @country.overview.deep_merge(vaccine: vaccine))
      rescue ActiveRecord::RecordInvalid => e
        e.record.errors.full_messages.each { |msg| @errors << "#{e.record.class.name} - #{msg}" }
      end
    end
  end
end
