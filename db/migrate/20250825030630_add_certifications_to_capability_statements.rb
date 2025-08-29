class AddCertificationsToCapabilityStatements < ActiveRecord::Migration[7.2]
  def change
    add_column :capability_statements, :certifications, :jsonb
  end
end
