class Company < ApplicationRecord
  has_rich_text :description

  validates_with EmailDomainValidator

end
