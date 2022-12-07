class CreateAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :areas do |t|
     t.string     :name
     t.string     :description
     t.string     :frequency
     t.string     :days_since_completed
     t.string     :assigned_to
     t.string     :assigned_to_email
     t.string     :notes
     t.string     :status
     t.timestamps
    end  
  end
end
