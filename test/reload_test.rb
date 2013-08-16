require_relative 'test_helper'

class TestReload < TestDsl::TestCase

  describe 'autoreloading' do
    after { Byebug.settings[:autoreload] = true }

    it 'must notify that automatic reloading is on by default' do
      enter 'reload'
      debug_file 'reload'
      check_output_includes \
        'Source code is reloaded. Automatic reloading is on.'
    end

    it 'must notify that automatic reloading is off if setting changed' do
      enter 'set noautoreload', 'reload'
      debug_file 'reload'
      check_output_includes \
        'Source code is reloaded. Automatic reloading is off.'
    end
  end

  describe 'reloading' do
    after { change_line_in_file(fullpath('reload'), 4, 'a = 4') }
    it 'must reload the code' do
      enter 'break 3', 'cont', 'l 4-4', -> do
        change_line_in_file(fullpath('reload'), 4, 'a = 100')
        'reload'
      end, 'l 4-4'
      debug_file 'reload'
      check_output_includes '4: a = 100'
    end
  end

  describe 'Post Mortem' do
    after { change_line_in_file(fullpath('post_mortem'), 7, '        z = 4') }

    it 'must work in post-mortem mode' do
      enter 'cont', -> do
        change_line_in_file(fullpath('post_mortem'), 7, 'z = 100')
        'reload'
      end, 'l 7-7'
      debug_file 'post_mortem'
      check_output_includes '7: z = 100'
    end
  end

end
