class SpanishVatValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    resul = if value.length != 9
              false
            elsif value =~ /[0-9]{8}[a-zA-Z]/i
              valid_nif?(value)
            elsif value =~ /[xyzXYZ][0-9]{7,8}[a-zA-Z]/i
              valid_nie?(value)
            end
    record.errors[attribute] << (options[:message] || "is invalid NIF/NIE") unless resul
  end

  private

  def valid_nif?(value)
    nif_letters = "TRWAGMYFPDXBNJZSQVHLCKE"
    numbers = value.chop
    value.upcase == numbers + nif_letters[numbers.to_i % nif_letters.length]
  end

  def valid_nie?(value)
    value[0] = case value[0]
               when /[xX]/i
                 "0"
               when /[yY]/i
                 "1"
               when /[zZ]/i
                 "2"
               end
    valid_nif?(value)
  end
end
