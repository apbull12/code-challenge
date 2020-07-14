class EmailDomainValidator < ActiveModel::Validator
  def validate(record)
    if  record.email.present? && record.email.split('@').last != 'getmainstreet.com'
      record.errors.add(:email, 'invalid email address.')
    end
  end
end
