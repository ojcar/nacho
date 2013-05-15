class AddReadColumnToFeedEntries < ActiveRecord::Migration
  def change
    add_column :feed_entries, :read, :boolean, :default => false
  end
end
