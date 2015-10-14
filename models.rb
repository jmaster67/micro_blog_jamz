class User < ActiveRecord::Base
	has_many :posts
	has_one  :profile
    has_many :follows, foreign_key: :followee_id
    has_many :followings, foreign_key: :follower_id, class_name: "::Follow"
    has_many :followers, through: :follows, class_name: User
    has_many :followees, through: :followings, class_name: User
	
end

class Post < ActiveRecord::Base
	belongs_to :user
end
	
class Profile < ActiveRecord::Base
	belongs_to :user
end

class Follow < ActiveRecord::Base
  # here we are basically telling ActiveRecord to define the
  #   @follow.follower method
  #   (assuming we have a @follower instance variable)
  #   and we are telling it to return an object of class type User
  belongs_to :follower, foreign_key: :follower_id, class_name: User

  # here we are basically telling ActiveRecord to define the
  #   @follow.followee method
  #   (assuming we have a @followee instance variable)
  #   and we are telling it to return an object of class type User
  belongs_to :followee, foreign_key: :followee_id, class_name: User
end