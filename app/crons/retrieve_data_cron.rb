require 'sidekiq-scheduler'

class RetrieveDataCron
  include Sidekiq::Worker

  def perform(country_code, type)
    provider = "Provider::Retrieve#{type.classify}Data".safe_constantize
    if provider.present?
      service = provider.new(country_code: country_code).perform
      service.errors.each { |message| Sidekiq.logger.error message } unless service.valid?
    else
      Sidekiq.logger.error 'Provider not found'
    end
  end
end
