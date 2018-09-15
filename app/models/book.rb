class Book
  #Modules 
  include Mongoid::Document
  include Mongoid::Timestamps

  JSON_LIST = [:_id,:book_name,:short_description,:long_description,:page_index,:publication_date,:genre]

  #Database Association
  belongs_to :author
  has_many :reviews, dependent: :destroy

  #Database Field Defination
  field :book_name, type: String,default: ""
  field :short_description, type: String,default: ""
  field :long_description, type: String,default: ""
  field :page_index, type: Array,default: 0
  field :publication_date, type: Date
  field :genre, type: Array
  field :is_deleted, type: Boolean, default: false

  #Scope
  default_scope -> { where(is_deleted: false) }

  #Validation
  validates_associated :author
  validates_associated :reviews
  validates :book_name, :short_description, :long_description, :page_index,:publication_date,:genre, :presence => true
  validate :validate_genre
  def validate_genre
    genres_arr = ["Science Fiction", "Satire", "Drama", "Action and Adventure", "Romance", "Mystery", "Horror", "Self Help", "Fantasy"]
    if !genre.is_a?(Array) || genre.detect{|g| !genres_arr.include?(g)}
      errors.add(:genre, :invalid)
    end
  end

  #methods
  def self.search_for_books search_value
    or_cond = [];  
    or_cond << {:book_name =>  /#{search_value}.*/i};
    or_cond << {:short_description => /#{search_value}/i};
    or_cond << {:long_description => /#{search_value}/i};
    or_cond << {:genre => {'$in' =>  search_value.split(" ").map{|val|/#{val}/i}}};
    all_cond = {"$or" => or_cond}
        
    books = Book.where(all_cond).as_json(
      only: Book::JSON_LIST, 
      include: {
        author: {only: Author::JSON_LIST, methods: [:profile_pic_url]}, 
        reviews: {only: Review::JSON_LIST}
      }
    )

    return books
  end
end
