class Company < ApplicationRecord
  has_rich_text :description

  validates_with EmailDomainValidator
  searchkick

  def search_data
    zipcode_info = ZipCodes.identify(zip_code)
    attributes.merge!(city: zipcode_info[:city], state: zipcode_info[:state_name]) if zipcode_info.present?
  end

end
