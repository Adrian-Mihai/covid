module Api
  module V1
    class CountrySerializer < ActiveModel::Serializer
      attributes :id, :code, :name, :population
    end
  end
end
