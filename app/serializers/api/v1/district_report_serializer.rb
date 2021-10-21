module Api
  module V1
    class DistrictReportSerializer < ActiveModel::Serializer
      attributes :date, :cases
    end
  end
end
