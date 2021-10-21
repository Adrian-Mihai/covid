module Api
  module V1
    class DiseaseReportSerializer < ActiveModel::Serializer
      attributes :date, :cases, :tests, :deaths, :recovered, :intensive_care, :hospitalized, :emergency_calls,
                 :information_calls, :home_isolation, :home_quarantine, :institutional_isolation,
                 :institutional_quarantine
    end
  end
end
