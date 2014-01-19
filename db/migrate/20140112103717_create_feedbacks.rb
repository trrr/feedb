class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.string :url, limit: 15, null: false
      t.string :title, limit: 40, null: false
      t.string :user_id, null: false

      t.timestamps
    end
  end
end
