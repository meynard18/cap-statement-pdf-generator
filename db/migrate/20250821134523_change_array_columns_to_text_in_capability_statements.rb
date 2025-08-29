class ChangeArrayColumnsToTextInCapabilityStatements < ActiveRecord::Migration[7.2]
  def change
    change_column :capability_statements, :core_competencies, :text
    change_column :capability_statements, :differentiators, :text
    change_column :capability_statements, :past_performance, :text
  end
end
