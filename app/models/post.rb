class Post < ActiveRecord::Base
  acts_as_taggable_on :keywords

  attr_accessible :body, :link, :title, :keywords

  scope :published, order("updated_at DESC").group("DATE(updated_at)")

  # before_save :set_tag_owner


  def to_param
    "#{id}-#{title}"
  end

  protected
    def set_tag_owner
      set_owner_keyword_list_on(current_user, :keywords, self.tag_list)
      self.tag_list = nil
    end
end
