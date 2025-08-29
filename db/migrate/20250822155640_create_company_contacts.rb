class CreateCompanyContacts < ActiveRecord::Migration[7.2]
  def change
    create_table :company_contacts do |t|
      t.references :capability_statement, null: false, foreign_key: true
      t.string :name
      t.string :email
      t.string :phone
      t.string :address
      t.string :website

      t.timestamps
    end
  end
end
