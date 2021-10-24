module Provider
  class RetrieveDiseaseData < Provider::Base
    private

    def provider
      "Provider::#{@country.code.downcase.classify}::RetrieveDiseaseData".safe_constantize
    end
  end
end

