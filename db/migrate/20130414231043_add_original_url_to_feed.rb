class AddOriginalUrlToFeed < ActiveRecord::Migration
  def change
  	add_column :feeds, :subscribed_url, :string
  end
end
