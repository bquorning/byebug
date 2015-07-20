require 'byebug/subcommands'

require 'byebug/commands/enable/breakpoints'
require 'byebug/commands/enable/display'

module Byebug
  #
  # Enabling custom display expressions or breakpoints.
  #
  class EnableCommand < Command
    include Subcommands

    def regexp
      /^\s* en(?:able)? (?:\s+ (.+))? \s*$/x
    end

    def description
      <<-EOD
        en[able][[ b[reakpoints]| d[isplay])][ n1[ n2[ ...[ nn]]]]]

        #{short_description}
      EOD
    end

    def short_description
      'Enables breakpoints or displays'
    end
  end
end
