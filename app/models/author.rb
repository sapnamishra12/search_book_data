class Author
  #Modules 
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip
  
  JSON_LIST = [:_id,:name,:author_bio,:academics,:awards,:profile_pic]

  #Database Association
  has_many :books, dependent: :destroy

  #Database Field Defination
  field :name, type: String,default: ""
  field :author_bio, type: String,default: ""
  field :academics, type: String,default: ""
  field :awards, type: String,default: ""
  field :is_deleted, type: Boolean, default: false
  has_mongoid_attached_file :profile_pic,
	styles: { thumb: "50x50", medium: "300x300"},
	:default_url => "default-profile.png"

  #Scope
  default_scope -> { where(is_deleted: false) }

  #Validation
  validates_attachment_content_type :profile_pic, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  validates_associated :books
  validates :name, :author_bio, :academics, :awards, :presence => true
  validates :author_bio, length: { 
  	in: 50..100, 
  	:too_short => "must have at least %{count} words",
    :too_long => "%{count} characters is the maximum allowed"
  }

  #methods
  def profile_pic_url
    self.profile_pic.url(:thumb)
  end

  def self.search_for_authors search_value
    or_cond = [];  
    or_cond << {:name => /#{search_value}.*/i};
    or_cond << {:author_bio => /#{search_value}.*/i};
    or_cond << {:academics => /#{search_value}.*/i};
    or_cond << {:awards => /#{search_value}.*/i};
  
    all_cond = {"$or" => or_cond}
        
    authors = Author.where(all_cond).as_json(only: Author::JSON_LIST, 
      methods: [:profile_pic_url], include: {
        books: {only: Book::JSON_LIST, include: {
          reviews: {only: Review::JSON_LIST}
        }}
      })

    return authors
  end

end
