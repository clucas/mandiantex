class SearchSuggestion
  def self.terms_for(prefix)
    $redis.zrevrange "search-suggestions:#{prefix.downcase}", 0, 9
  end
  
  def self.index_items
    MediaItem.find_each do |media_item|
      index_term(media_item.category)
      media_item.title.split.each { |t| index_term(t) }
      media_item.author.split.each { |t| index_term(t) }
      media_item.publisher.split.each { |t| index_term(t) }
    end
  end
  
  def self.index_term(term)
    1.upto(term.length-1) do |n|
      prefix = term[0, n]
      $redis.zincrby "search-suggestions:#{prefix.downcase}", 1, term.downcase
    end
  end
end
