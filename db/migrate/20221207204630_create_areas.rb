class CreateAreas < ActiveRecord::Migration[7.0]
  def change
    create_table :areas do |t|
     t.string     :name
     t.string     :description
     t.integer    :frequency
     t.date       :date_completed
     t.string     :assigned_to
     t.string     :assigned_to_email
     t.string     :notes
     t.boolean    :completed, default: false
     t.timestamps
    end  
  end
end
