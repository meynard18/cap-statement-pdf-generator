class CapabilityStatement < ApplicationRecord
  has_one :company_contact, dependent: :destroy
  accepts_nested_attributes_for :company_contact
  store_accessor :ai_output, :core_competencies, :differentiators, :past_performance
  has_one_attached :company_logo
end
