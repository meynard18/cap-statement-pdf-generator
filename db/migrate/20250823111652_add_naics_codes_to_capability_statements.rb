class AddNaicsCodesToCapabilityStatements < ActiveRecord::Migration[7.2]
  def change
    add_column :capability_statements, :naics_codes, :jsonb
    remove_column :capability_statements, :core_competencies, :text
    remove_column :capability_statements, :differentiators, :text
    remove_column :capability_statements, :past_performance, :text
  end
end
