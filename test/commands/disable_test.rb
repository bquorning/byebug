require 'test_helper'

module Byebug
  #
  # Tests disabling breakpoints.
  #
  class DisableTestCase < TestCase
    def program
      strip_line_numbers <<-EOC
         1:  module Byebug
         2:    #
         3:    # Toy class to test breakpoints
         4:    #
         5:    class #{example_class}
         6:      def self.a(num)
         7:        num + 1
         8:      end
         9:
        10:      def b
        11:        3
        12:      end
        13:    end
        14:
        15:    y = 3
        16:
        17:    byebug
        18:
        19:    z = 5
        20:
        21:    #{example_class}.new.b
        22:    #{example_class}.a(y + z)
        23:  end
      EOC
    end

    def test_disable_breakpoints_with_short_syntax_sets_enabled_to_false
      enter 'break 21', 'break 22', -> { "disable b #{Breakpoint.first.id}" }

      debug_code(program) { assert_equal false, Breakpoint.first.enabled? }
    end

    def test_disable_breakpoints_with_short_syntax_properly_ignores_them
      enter 'b 21', 'b 22', -> { "disable b #{Breakpoint.first.id}" }, 'cont'

      debug_code(program) { assert_equal 22, frame.line }
    end

    def test_disable_breakpoints_with_full_syntax_sets_enabled_to_false
      enter 'b 21', 'b 22', -> { "disable breakpoints #{Breakpoint.first.id}" }

      debug_code(program) { assert_equal false, Breakpoint.first.enabled? }
    end

    def test_disable_breakpoints_with_full_syntax_properly_ignores_them
      enter 'break 21', 'break 22',
            -> { "disable breakpoints #{Breakpoint.first.id}" }, 'cont'

      debug_code(program) { assert_equal 22, frame.line }
    end

    def test_disable_all_breakpoints_sets_all_enabled_flags_to_false
      enter 'break 21', 'break 22', 'disable breakpoints'

      debug_code(program) do
        assert_equal false, Breakpoint.first.enabled?
        assert_equal false, Breakpoint.last.enabled?
      end
    end

    def test_disable_all_breakpoints_ignores_all_breakpoints
      enter 'break 21', 'break 22', 'disable breakpoints', 'cont'
      debug_code(program)

      check_output_doesnt_include 'Stopped by breakpoint'
    end

    def test_disable_without_an_argument_shows_help
      enter 'disable'
      debug_code(program)

      check_output_includes 'Disables breakpoints or displays'
    end
  end
end
