class Review
  #Modules 
  include Mongoid::Document
  include Mongoid::Timestamps

  JSON_LIST = [:_id,:book_id,:reviewer_name,:rating,:review_description]

  #Database Association
  belongs_to :book

  #Database Field Defination
  field :reviewer_name, type: String,default: ""
  field :rating, type: Integer,default: 0
  field :review_title, type: String,default: ""
  field :review_description, type: String,default: ""
  field :is_deleted, type: Boolean, default: false

  #Scope
  default_scope -> { where(is_deleted: false) }

  #Validation
  validates_associated :book
  validates :reviewer_name, :rating, :review_title, :review_description, :presence => true
  validates :rating, inclusion: { in: 0..5 }

  #methods
  def self.search_for_reviews search_value
    or_cond = [];  
    or_cond << {:review_title =>  /#{search_value}.*/i};
    or_cond << {:reviewer_name => /#{search_value}/i};
    all_cond = {"$or" => or_cond}
        
    reviews = Review.where(all_cond).as_json(
      only: Review::JSON_LIST, 
      include: {
        book: {only: Book::JSON_LIST}
      }
    )

    return reviews
  end

end
