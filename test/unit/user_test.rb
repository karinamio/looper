require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_many(:user_friendships)
  should have_many(:friends)
  should have_many(:pending_user_friendships)
  should have_many(:pending_friends)
  should have_many(:requested_user_friendships)
  should have_many(:requested_friends)
  should have_many(:blocked_user_friendships)
  should have_many(:blocked_friends)

  test "a user should enter a first name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end

  test "a user should enter a profile name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:profile_name].empty?	
  end

  test "a user should have a unique profile name" do
  	user = User.new
  	user.profile_name = users(:karina).profile_name
  	users(:karina)
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
  	user = User.new(first_name: "Karina", last_name: "Mio", email: "id@karinamio.com")
    user.password = user.password_confirmation = "password"
  	user.profile_name = "My Profile With Spaces"
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  	assert user.errors[:profile_name].include?("Must be formatted correctly.")
  end

  test "a user can have a correctly formatted profile name" do
    user = User.new(first_name: "Karina", last_name: "Mio", email: "id@karinamio.com")
    user.password = user.password_confirmation = "password"
    user.profile_name = 'karinamio'
    assert user.valid?
  end

  test "that no error is raised when trying to access a friend list" do
    assert_nothing_raised do
      user(:karina).friends
    end
  end

  test "that creating friendships on a user works" do
    users(:karina).pending_friends << users(:bob)
    users(:jason).pending_friends.reload
    assert users(:karina).friends.include?(users(:bob))
  end	

  test "that calling to_param on a user returns the profile_name" do
    assert_equal "karinamio", users(:karina).to_param
  end

  context "#has_blocked?" do
    should "return true if a user has blocked another user" do
        assert users(:karina).has_blocked?(users(:blocked_friend))
    end
    should "return false if a user has notblocked another user" do
        assert !users(:karina).has_blocked?(users(:bob))
    end
  end
  
end
