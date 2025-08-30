class AddPaidToCapabilityStatement < ActiveRecord::Migration[7.2]
  def change
    add_column :capability_statements, :paid, :boolean
  end
end
