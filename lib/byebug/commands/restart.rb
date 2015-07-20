require 'byebug/command'

module Byebug
  #
  # Restart debugged program from within byebug.
  #
  class RestartCommand < Command
    self.allow_in_control = true

    def regexp
      /^\s* (?:restart|R) (?:\s+(?<args>.+))? \s*$/x
    end

    def description
      <<-EOD
        restart [args]

        #{short_description}

        This is a re-exec - all byebug state is lost. If command arguments are
        passed those are used.
      EOD
    end

    def short_description
      'Restarts the debugged program'
    end

    def execute
      if Byebug.mode == :standalone
        cmd = "#{Gem.bin_path('byebug', 'byebug')} #{$PROGRAM_NAME}"
      else
        cmd = $PROGRAM_NAME
      end

      if @match[:args]
        cmd += " #{@match[:args]}"
      else
        require 'shellwords'
        cmd += " #{$ARGV.compact.shelljoin}"
      end

      puts pr('restart.success', cmd: cmd)
      exec(cmd)
    end
  end
end
