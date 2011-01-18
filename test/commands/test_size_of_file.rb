require 'test_helper'

class TestSizeOfFile < Test::Unit::TestCase
  include BeNotified::Commands
  
  def test_file_doesnt_exist
    File.expects(:exists?).returns(false)
    
    assert_raise ArgumentError do
      size_of_file("test.txt")
    end
  end
  
  def test_file_size
    File.expects(:exists?).returns(true)
    File.expects(:size).returns(200)
    
    assert_equal(200, size_of_file("test.txt"))
  end
  
  def test_file_size_in_KB
    assert_equal(4_000, 4.KB)
  end
  
  def test_file_size_in_MB
    assert_equal(4_000_000, 4.MB)
  end
  
  def test_file_size_in_GB
    assert_equal(4_000_000_000, 4.GB)
  end
end