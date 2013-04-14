class CreateFeedEntries < ActiveRecord::Migration
  def change
    create_table :feed_entries do |t|
      t.string :title
      t.string :url
      t.text :content
      t.datetime :published_at
      t.string :guid
      t.string :author
      t.integer :feed_id

      t.timestamps
    end
    
    add_index 'feed_entries', ['feed_id']
  end
end
