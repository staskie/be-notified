require 'test_helper'

class TestProgramRunning < Test::Unit::TestCase
  include BeNotified::Commands
  
  def test_program_not_running
    expects(:run_system).with("ps -ef | grep -i Foobar | grep -v grep").returns("")
    assert_equal true, program_not_running?('Foobar')
  end
  
  def test_program_running
    expects(:run_system).with("ps -ef | grep -i Dock | grep -v grep").returns(PS_OUT)
    assert_equal true, program_running?("Dock")
  end
    
  def test_raising_error_on_windows
    expects(:running_on_windows?).returns(true)
    
    assert_raise RuntimeError do
      program_running?("Dock")
    end
  end
  
  PS_OUT =<<-END
  502   101    97   0   0:08.43 ??         0:44.19 /System/Library/CoreServices/Dock.app/Contents/MacOS/Dock  
  END
end
