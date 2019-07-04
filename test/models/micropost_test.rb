require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:test)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end
  test 'should be valid' do
    assert @micropost.valid?
  end
  test 'user id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end
  # Test content
  test 'content should be presence' do
    @micropost.content = ''
    assert_not @micropost.valid?
  end
  test 'content should be less than 140 character' do
    @micropost.content = 'a'*141
    assert_not @micropost.valid?
  end

  test 'order should be most recent first' do
    micropost = microposts(:most_recent)
    assert_equal micropost, Micropost.first
  end
end
