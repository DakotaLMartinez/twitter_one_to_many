class User

  
   
  # short for the following
  # def username
  #   @username
  # end

  attr_reader :username
  def tweets 
    @tweets
  end
  def initialize(attributes = {})
    @username = attributes[:username]
    @tweets = []
  end

  def post_tweet(message)
    Tweet.new({message: message, user: self})
  end
 
 
end

class Tweet

  @@all = []

  def self.all
    @@all
  end

  attr_reader :message, :user
  def initialize(attributes = {})
    @message = attributes[:message]
    @user = attributes[:user]
    @@all << self
    @user.tweets << self
  end

  def username  
    self.user.username
  end

  def delete #
    Tweet.all.delete(self)
    user.tweets.delete(self)
  end
end