namespace :model do
  desc "Populate data for Models Author,Book,Review"
  task :populate => :environment do 
    require 'faker'

    ##Reset database 
    Rake::Task['db:reset'].invoke
    
    ##Create a User for authentication
    User.create(email:'admin@example.com', password:'admin@123', password_confirmation:'admin@123')

    # Populate 100 Authors
    100.times do
      Author.create! do |a|
        a.name = Faker::Book.author
        a.author_bio = Faker::Lorem.paragraph_by_chars(60, false)
        a.academics = Faker::Lorem.word
        a.awards = Faker::Lorem.word
        a.profile_pic = File.open(File.join(Rails.root, "public", "assets","images", "avatar#{rand(1..10)}.png"))
      end
    end

    ##Books Genre
    genres_arr = ["Science Fiction", "Satire", "Drama", "Action and Adventure", "Romance", "Mystery", "Horror", "Self Help", "Fantasy"]

    ##Get Authors and create 5 books for each to popluate 500 books
    authors = Author.all
    authors.each do |author|
      5.times do
        Book.create! do |b|
          b.author_id = author.id
          b.book_name = Faker::Book.title
          b.short_description = Faker::Lorem.sentence(rand(2..5), true,rand(3..5))
          b.long_description = Faker::Lorem.paragraph_by_chars(256, false)
          b.publication_date = Faker::Date.between_except(1.year.ago, 1.year.from_now, Date.today)
          b.genre = genres_arr.sample(rand(3..6))
          page_index = []
          (0..rand(15..30)).each do |i|
            if i == 0
              page_no = 5
            else
              previous_chap = page_index[i-1]
              page_no = previous_chap[:page_no]+Faker::Number.between(10, 30)
            end
            page_index.push({:id => i, :name => Faker::Lorem.sentence(rand(1..5)), :page_no => page_no})
          end
          b.page_index = page_index
        end
      end
    end

    ##Get 250 books create a review for each to get 150 more reviews
    books = Book.order_by(["created_at", "asc"]).limit(250)
    books.each do |book|
      Review.create! do |r|
        r.book_id = book.id
        r.rating = Faker::Number.between(1, 5)
        r.reviewer_name = Faker::Book.author
        r.review_title = Faker::Lorem.sentence(rand(3..5), true)
        r.review_description = Faker::Lorem.sentence(rand(2..5), true,rand(3..5))
      end
    end
  end
end