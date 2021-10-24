module Provider
  class RetrieveVaccineData < Provider::Base
    private

    def provider
      "Provider::#{@country.code.downcase.classify}::RetrieveVaccineData".safe_constantize
    end
  end
end
