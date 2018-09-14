require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
      password: "foobar", password_confirmation: "foobar")#正しいデータ
  end

  test "should be valid" do
    assert @user.valid?   #@userは有効？
  end

  test "name should be present" do
    @user.name = "     "  #nameが必須空白ではだめ　保存されない
    assert_not @user.valid? #@userは有効ではない！
  end

  test "email should be present" do
    @user.email = "     "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should reject invalid addresses" do #emailのフォーマット検証 %w[aa bb cc] = [aa, bb ,cc]
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address| #なんか色々あるメアドを一つずつ取り出して検証
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do #emailは一つだけ!
    duplicate_user = @user.dup  #.dupは全く同じものを作るつまりduplcate_user === @user
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do##email  を小文字にしてるか？？
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email##リロードで@userのemailの値をDBで保存されている奴を
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6 #PWは空白だめ空白６個入れる
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5 #PWは6文字以上
    assert_not @user.valid?
  end

end