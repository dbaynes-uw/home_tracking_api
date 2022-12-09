class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :area
      t.string     :name
      t.string     :description
      t.string     :assigned_to
      t.string     :assigned_to_email
      t.string     :notes
      t.string     :status
      t.timestamps
    end   
  end
end
