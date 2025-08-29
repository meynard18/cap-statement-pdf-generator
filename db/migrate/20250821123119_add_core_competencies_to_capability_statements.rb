class AddCoreCompetenciesToCapabilityStatements < ActiveRecord::Migration[7.2]
  def change
    add_column :capability_statements, :company_name, :text
    add_column :capability_statements, :introduction, :text
    add_column :capability_statements, :core_competencies, :text, array: true, default: []
    add_column :capability_statements, :differentiators, :text, array: true, default: []
    add_column :capability_statements, :past_performance, :text, array: true, default: []
    add_column :capability_statements, :contact_info, :jsonb, default: {}
    add_column :capability_statements, :cage_code, :string
    add_column :capability_statements, :uei, :string
    add_column :capability_statements, :accepts_credit_cards, :boolean, default: false
  end
end
