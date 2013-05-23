module FeedsHelper
  def get_word_list
    return "" if @feed.nil?
    return @feed.folders.join(",") if @feed.folders.present?
    return params[:word_list] if params[:word_list].present?
  end
end
