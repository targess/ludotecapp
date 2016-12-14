class Player < ApplicationRecord
  has_and_belongs_to_many :events
  has_many :loans
  has_many :participants

  validates :firstname, presence: true
  validates :lastname, presence: true
  validates :dni, presence: true, length: { is: 9 },
                  format: { with: /[a-zA-Z]\z/, message: "last char has to be a letter" },
                  uniqueness: { case_sensitive: false }

  validate :dni_must_have_valid_format

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  validates_size_of :phone, is: 9

  def name
    firstname+" "+lastname
  end

  def get_dni_and_name
    dni+" | "+firstname+" "+lastname
  end

  def age
    return "" unless birthday
    today = Date.today
    day = Date.new(today.year, birthday.month, birthday.day)
    day.year - birthday.year - (day > today ? 1 : 0)
  end

  private

  def dni_must_have_valid_format
    nif_letters = 'TRWAGMYFPDXBNJZSQVHLCKE'
    dni_numbers = dni.chop

    if dni != dni_numbers + nif_letters[dni_numbers.to_i % nif_letters.length]
      errors.add(:dni, "is invalid dni")
    end
  end
end
