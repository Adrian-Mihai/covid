module Provider
  class RetrieveDiseaseData
    attr_reader :errors

    def initialize(country_code:)
      @errors = []
      @country = Country.find_by!(code: country_code)
    rescue ActiveRecord::RecordNotFound => e
      @errors << "Couldn't find #{e.model}"
    end

    def valid?
      @errors.empty?
    end

    def perform
      return self unless valid?

      provider = "Provider::#{@country.code.downcase.classify}::RetrieveDiseaseData".safe_constantize
      if provider.nil?
        @errors << "Unknown provider for #{@country.name}"
        return self
      end

      service = provider.new(code: @country.code).perform
      @errors += service.errors unless service.valid?
      self
    end
  end
end

