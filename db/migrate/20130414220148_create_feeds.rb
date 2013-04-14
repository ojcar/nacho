class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :url
      t.string :feed_url
      t.string :title
      t.datetime :last_modified

      t.timestamps
    end
  end
end
