require 'test_helper'

class TestCommands < Test::Unit::TestCase
  include BeNotified::Commands
  
  def setup
    files = mock
    files.stubs(:each).multiple_yields('test1.rb', 'test2.rb', 'test.txt')
    
    Dir.stubs(:glob).returns(files)
  end
  
  def test_number_of_files_in_directory
    File.stubs(:file?).returns(true)
    
    assert_equal 3, number_of_files('.')
  end
  
  def test_number_of_files_in_directory_with_given_mask
    File.stubs(:file?).returns(true)
    
    assert_equal(2, number_of_files('.', /\.rb$/))
  end
  
  def test_number_of_files_in_directory_that_doesnt_exist
    File.stubs(:exists?).returns(false)
    
    assert_raise ArgumentError do
      number_of_files('.')
    end
  end
  
  def test_number_of_files_in_directory_with_mask
    File.stubs(:exists?).returns(true)
    
    assert_raise ArgumentError do
      number_of_files('.', "")
    end
  end
  
  def test_number_of_files_returns_zero_if_there_is_no_files_in_directory
    File.stubs(:file?).returns(false)
    
    assert_equal 0, number_of_files(".")
  end
end