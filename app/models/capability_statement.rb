class CapabilityStatement < ApplicationRecord
  has_one :company_contact, dependent: :destroy
  accepts_nested_attributes_for :company_contact
  store_accessor :ai_output, :core_competencies, :differentiators, :past_performance
  has_one_attached :company_logo

  
  validates :company_name, presence: {message: 'field is required to generate your capability statement'}
  validates :introduction, presence: {message: 'field is required to generate your capability statement'}
  validates :core_competencies, presence: {message: 'field is required to generate your capability statement'}
  validates :differentiators, presence: {message: 'field is required to generate your capability statement'}
  validates :past_performance, presence: {message: 'field is required to generate your capability statement'}

   def normalized_ai_output
    raw = ai_output.is_a?(String) ? JSON.parse(ai_output) : ai_output || {}

    {
      "introduction"      => raw["introduction"].to_s,
      "core_competencies" => Array(raw["core_competencies"]).join("\n"),
      "differentiators"   => Array(raw["differentiators"]).join("\n"),
      "past_performance"  => Array(raw["past_performance"]).join("\n")
    }
  end
  
end
