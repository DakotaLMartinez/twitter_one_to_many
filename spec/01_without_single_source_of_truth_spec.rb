# * Create a User class. The class should have these methods:
#   * `User#initialize` which takes a username
#   * `User#username` reader method
#   * `User#tweets` that returns an array of Tweet instances
#   * `User#post_tweet` that takes a message, creates a new tweet, and adds it to the user's tweet collection
# * Create a Tweet class. The class should have these methods:
#   * `Tweet#message` that returns a string
#   * `Tweet#user` that returns an instance of the user class
#   * `Tweet.all` that returns all the Tweets created.
#   * `Tweet#username` that returns the username of the tweet's user
require "twitter_one_to_many/twitter_without_single_source_of_truth"
RSpec.describe "Without Single Source of Truth" do 
  describe "User" do 
    describe "#initialize" do
      it "takes a hash of attributes including a username as an argument" do 
        expect{ User.new(username: "Dakota") }.not_to raise_error
      end

      it "assigns the username from the hash as the value of the @username instance variable" do 
        user = User.new(username: "Jose")
        expect(user.instance_variable_get("@username")).to eq("Jose")
      end

      it "creates a @tweets attribute that will contain an array of tweets" do 
        user = User.new(username: "Rumiko")
        expect(user.instance_variable_get("@tweets")).to eq([])
      end
    end

    describe "#username" do
      it "returns the value of the username attribute" do 
        user = User.new(username: "Angela")
        expect(user.username).to eq("Angela")
      end
    end


  end

  describe "Tweet" do 
    describe "#initialize" do
      it "takes a hash of attributes as an argument including a message and a user" do 
        user = User.new(username: "Dakota")
        expect{ Tweet.new(message: "A burrito sounds really good right about now. #hungry", user: user) }.not_to raise_error
      end

      it "assigns the @message instance variable to the value of the message from the attributes hash" do 
        user = User.new(username: "Jose")
        tweet = Tweet.new(message: "This new computer is awesome!!!", user: user)
        expect(tweet.instance_variable_get("@message")).to eq("This new computer is awesome!!!")
      end

      it "creates a @user attribute that will store the value of the user (who made the tweet) passed from the attributes hash" do 
        user = User.new(username: "Joshua")
        tweet = Tweet.new(message: "Chia seeds, Almond milk and Honey in a mason jar overnight = happiness", user: user)
        expect(tweet.instance_variable_get("@user")).to eq(user)
      end

      it "adds new tweets to a class variable called @@all" do 
        user = User.new(username: "Sandra")
        tweet = Tweet.new(message: "Lennon has a mouth full of the rug again #everythingisfood", user: user)
        expect(Tweet.class_variable_get("@@all")).to include(tweet)
      end
    end

    describe ".all" do 
      it "returns an array of all tweets created" do 
        user = User.new(username: "Dakota")
        tweet_1 = Tweet.new(message: "When you're so tired you learn to lucid dream that you're stilling doing your homework #timetofly", user: user)
        tweet_2 = Tweet.new(message: "If I only had to eat spinach curry for the rest of my life, I think that'd just be ok", user: user)
        expect(Tweet.all).to include(tweet_1)
        expect(Tweet.all).to include(tweet_2)
      end
    end

    describe "#message" do
      it "returns the value of the tweet's message attribute" do 
        user = User.new(username: "Angela")
        tweet = Tweet.new(message: "When you make it to the burrito place right before it closes #relieved", user: user)
        expect(tweet.message).to eq("When you make it to the burrito place right before it closes #relieved")
      end
    end

    describe "#username" do
      it "returns the username of the user who made the tweet" do 
        user = User.new(username: "Angela")
        tweet = Tweet.new(message: "When you make it to the burrito place right before it closes #relieved", user: user)
        expect(tweet.username).to eq("Angela")
      end
    end
  end

  describe "One to Many Relationship" do 
    describe "User#tweets" do 
      it "returns an array of tweets belonging to the user" do 
        user = User.new(username: "Adam") 
        expect(user.tweets).to eq(user.instance_variable_get("@tweets"))
      end
    end

    describe "User#post_tweet(message)" do 
      it "creates a tweet instance, associates it with the user and returns it" do 
        user = User.new(username: "Katelyn")
        tweet = user.post_tweet("Ruby is awesome!!!")
        expect(user.tweets.length).to eq(1)
        expect(user.tweets.first).to be_a(Tweet)
        expect(user.tweets.first.message).to eq("Ruby is awesome!!!")
        expect(tweet).to be_a(Tweet)
      end
    end
  end

  describe "Challenges when we don't have a Single Source of Truth" do
    describe "Tweet#initialize" do
      it "must add the tweet to the user's array of tweets as well as Tweet.all" do 
        Tweet.class_variable_set("@@all", [])
        user = User.new(username: "Angela")
        tweet = Tweet.new(message: "When you make it to the burrito place right before it closes #relieved", user: user)
        expect(user.tweets).to include(tweet)
      end
    end
    describe "Tweet#delete" do 
      it "must delete a tweet both from the user's collection of tweets and from Tweet.all" do  
        Tweet.class_variable_set("@@all", [])
        user = User.new(username: "Angela")
        tweet = Tweet.new(message: "When you make it to the burrito place right before it closes #relieved", user: user)
        tweet.delete
        expect(Tweet.all).not_to include(tweet)
        expect(user.tweets).not_to include(tweet)
      end
    end
  end
end