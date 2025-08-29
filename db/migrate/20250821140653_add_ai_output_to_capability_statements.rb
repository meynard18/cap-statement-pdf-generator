class AddAiOutputToCapabilityStatements < ActiveRecord::Migration[7.2]
  def change
    add_column :capability_statements, :ai_output, :jsonb
  end
end
