require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                    password: 'foobar', password_confirmation:'foobar')
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end 

  test "name should be shortish" do
    @user.name = "a"*51
    assert_not @user.valid?
  end

  test "name should be present" do
    @user.name = "    "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "email should be less than 255 charachters" do
    @user.email = "a" * 255 + "@example.com"
    assert_not @user.valid?
  end

  test "email address should be lowercased" do
    @user.email = "ollY@example.Com"
    @user.save
    assert_equal @user.reload.email, "olly@example.com"
  end

  test "email address should be unique" do
    dup_user = @user.dup
    dup_user.email = dup_user.email.upcase
    @user.save
    assert_not dup_user.valid?
  end

  test "email address should be downcased once saved" do
    dup_user = @user.dup
    dup_user.email = dup_user.email.upcase
    @user.save
    assert_not dup_user.valid?
  end

  test "email should accept a valid email" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                             first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?
    end
  end

  test "authenticated? should return falsse for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
  test "email should reject an invalid email" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                               foo@bar_baz.com foo@bar+baz.com foo@example..com]
    invalid_addresses.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should be invalid"
    end
  end
end
