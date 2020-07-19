class Company < ApplicationRecord
  has_rich_text :description

  validates_with EmailDomainValidator

  after_commit :add_zip_code_info, on: [:create, :update]

  def add_zip_code_info
    if zip_code.present? && zip_code.length == 5
      company = Company.find_by(id: id)
      zipcode_info = ZipCodes.identify(zip_code)
      company.update_columns(city: zipcode_info[:city], state: zipcode_info[:state_name]) if zipcode_info.present?
    end
  end

end
