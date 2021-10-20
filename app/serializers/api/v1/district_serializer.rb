module Api
  module V1
    class DistrictSerializer < ActiveModel::Serializer
      attributes :id, :code, :name, :population
    end
  end
end
