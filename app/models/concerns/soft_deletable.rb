module SoftDeletable
  extend ActiveSupport::Concern

  MODEL_CONFIDENTIAL_FIELDS = {
    'Player' => [:firstname, :lastname, :email, :dni],
    'Boardgame' => [:internalcode]
  }.freeze

  included do
    acts_as_paranoid
    before_destroy :not_removed_with_pending_loans,
                   :mark_confidential_fields_as_deleted
    after_destroy :really_destroy_when_useless
  end

  private

  def free_to_loan?
    active_loans.blank?
  end

  def not_removed_with_pending_loans
    return if free_to_loan?

    errors.add(:destroy, "Cannot delete #{model_name.human} with pending loans")
    throw(:abort)
  end

  def mark_confidential_fields_as_deleted
    fields = MODEL_CONFIDENTIAL_FIELDS[model_name.human]
    hash_of_fields_to_mark = fields.map { |field| [field, 'DEL'] }.to_h

    update_columns(hash_of_fields_to_mark)
  end

  def really_destroy_when_useless
    return if frozen? || respond_to?(:loans) && loans.present?
    return if model_name.human == 'Player' && participants.present?
    return if model_name.human == 'Boardgame' && tournaments.present?
    really_destroy!
  end
end
