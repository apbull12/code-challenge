class EmailDomainValidator < ActiveModel::Validator
  def validate(record)
    if  record.email.present? && record.email.split('@').last != 'getmainstreet.com'
      record.errors.add(:email, 'Invalid email address, please change the Email domain to "getmainstreet.com"')
    end
  end
end
