require 'byebug/helpers/thread'

module Byebug
  #
  # Reopens the +thread+ command to define the +list+ subcommand
  #
  class ThreadCommand < Command
    #
    # Information about threads
    #
    class ListSubcommand < Command
      include Helpers::ThreadHelper

      def regexp
        /^\s* l(?:ist)? \s*$/x
      end

      def description
        <<-EOD
          th[read] l[ist] <thnum>

          #{short_description}
        EOD
      end

      def short_description
        'Lists all threads'
      end

      def execute
        contexts = Byebug.contexts.sort_by(&:thnum)

        thread_list = prc('thread.context', contexts) do |context, _|
          thread_arguments(context)
        end

        print(thread_list)
      end
    end
  end
end
