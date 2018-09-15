class SearchService
	def self.search_from_models search_value
    data = Hash.new
    data[:authors] = Author.search_for_authors(search_value)
    data[:books] = Book.search_for_books(search_value)
    data[:reviews] = Review.search_for_reviews(search_value)
    return data
	end
end