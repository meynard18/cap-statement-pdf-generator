class UpdateCompanyContactAddressFields < ActiveRecord::Migration[7.2]
  def change
    remove_column :capability_statements, :contact_info, :jsonb
    remove_column :company_contacts, :address, :string
    add_column :company_contacts, :street, :string
    add_column :company_contacts, :city, :string
    add_column :company_contacts, :state, :string
    add_column :company_contacts, :postal_code, :string
  end
end
