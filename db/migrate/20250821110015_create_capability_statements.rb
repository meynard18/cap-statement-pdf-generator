class CreateCapabilityStatements < ActiveRecord::Migration[7.2]
  def change
    create_table :capability_statements do |t|
      t.timestamps
    end
  end
end
