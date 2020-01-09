class CreateFollows < ActiveRecord::Migration[5.2]
  def change
    create_table :follows do |t|
      t.integer :follow_type, default: 0
      t.references :user, foreign_key: true
      t.integer :f_user_id, foreign_key: true

      t.timestamps
    end
  end
end
