class PopulateDatabase < ActiveRecord::Migration[6.1]
  class Country < ApplicationRecord
    has_many :districts
  end

  class District < ApplicationRecord
    belongs_to :country
  end

  def change
    country = Country.find_or_create_by!(code: data.dig(:country, :code)) do |c|
      c.name = data.dig(:country, :name)
    end

    data[:districts].each do |district|
      District.find_or_create_by!(code: district[:code]) do |d|
        d.name = district[:name]
        d.country = country
      end
    rescue ActiveRecord::RecordInvalid => e
      e.record.errors.full_messages.each { |msg| Rails.logger.warn "#{e.record.class.name} - #{msg}" }
      next
    end
  rescue ActiveRecord::RecordInvalid => e
    e.record.errors.full_messages.each { |msg| Rails.logger.warn "#{e.record.class.name} - #{msg}" }
    nil
  end

  private

  def data
    {
      country: {
        name: 'Romania',
        code: 'RO'
      },
      districts: [
        {
          code: 'AB',
          name: 'Alba'
        },
        {
          code: 'AR',
          name: 'Arad'
        },
        {
          code: 'AG',
          name: 'Arges'
        },
        {
          code: 'BC',
          name: 'Bacau'
        },
        {
          code: 'BH',
          name: 'Bihor'
        },
        {
          code: 'BN',
          name: 'Bistrita Nasaud'
        },
        {
          code: 'BT',
          name: 'Botosani'
        },
        {
          code: 'BV',
          name: 'Brasov'
        },
        {
          code: 'BR',
          name: 'Braila'
        },
        {
          code: 'BZ',
          name: 'Buzau'
        },
        {
          code: 'CS',
          name: 'Caras Severin'
        },
        {
          code: 'CL',
          name: 'Calarasi'
        },
        {
          code: 'CJ',
          name: 'Cluj'
        },
        {
          code: 'CT',
          name: 'Constanta'
        },
        {
          code: 'CV',
          name: 'Covasna'
        },
        {
          code: 'DB',
          name: 'Dambovita'
        },
        {
          code: 'DJ',
          name: 'Dolj'
        },
        {
          code: 'GL',
          name: 'Galati'
        },
        {
          code: 'GR',
          name: 'Giurgiu'
        },
        {
          code: 'GJ',
          name: 'Gorj'
        },
        {
          code: 'HR',
          name: 'Harghita'
        },
        {
          code: 'HD',
          name: 'Hunedoara'
        },
        {
          code: 'IL',
          name: 'Ialomita'
        },
        {
          code: 'IS',
          name: 'Iasi'
        },
        {
          code: 'IF',
          name: 'Ilfov'
        },
        {
          code: 'MM',
          name: 'Maramures'
        },
        {
          code: 'MH',
          name: 'Mehedinti'
        },
        {
          code: 'MS',
          name: 'Mures'
        },
        {
          code: 'NT',
          name: 'Neamt'
        },
        {
          code: 'OT',
          name: 'Olt'
        },
        {
          code: 'PH',
          name: 'Prahova'
        },
        {
          code: 'SM',
          name: 'Satu Mare'
        },
        {
          code: 'SJ',
          name: 'Salaj'
        },
        {
          code: 'SB',
          name: 'Sibiu'
        },
        {
          code: 'SV',
          name: 'Suceava'
        },
        {
          code: 'TR',
          name: 'Teleorman'
        },
        {
          code: 'TM',
          name: 'Timis'
        },
        {
          code: 'TL',
          name: 'Tulcea'
        },
        {
          code: 'VS',
          name: 'Vaslui'
        },
        {
          code: 'VL',
          name: 'Valcea'
        },
        {
          code: 'VN',
          name: 'Vrancea'
        },
        {
          code: 'B',
          name: 'Bucuresti'
        }
      ]
    }
  end
end
