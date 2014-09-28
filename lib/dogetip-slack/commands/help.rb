module DogetipSlack
  module Commands
    class Help < Base
      document 'help',
               usage: 'help [<command>]',
               description: 'Returns a list of commands, or specific information about one command.'

      def perform
        command = @parts[0]

        case
          when command.nil? then available_commands
          when public? then raise PrivateCommand
          when docs = Commands.docs(command) then single_command(docs)
          else "I don't know how to _#{command}_. Sorry."
        end
      end

      private

      def available_commands
        commands = Commands.list.map {|command| "_#{command}_"}
        "Such commands: #{commands.join ', '}. Use *help <command>* for more info."
      end
      
      def single_command(docs)
        [].tap do |response|
          if docs[:usage]
            response << "*Usage*: #{docs[:usage]}"
          end

          if docs[:examples]
            response << "*Example*: #{docs[:examples].map {|ex| '"' + ex + '"'}.join(', ')}"
          end

          response << "*Description*: #{docs[:description]}"
        end.join "\n"
      end
    end
  end
end