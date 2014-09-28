module DogetipSlack
  module Commands
    class Help < Base
      document 'help',
               usage: 'help [<command>]',
               description: 'Returns a list of commands, or specific information about one command.'

      def perform
        command = @parts[0]

        if command.nil?
          available_commands = Commands.list.map {|command| "_#{command}_"}
          "Such commands: #{available_commands.join ', '}. Use *help <command>* for more info."
        elsif public?
          raise PrivateCommand
        elsif docs = Commands.docs(command)
          [].tap do |response|
            if docs[:usage]
              response << "*Usage*: #{docs[:usage]}"
            end

            if docs[:examples]
              response << "*Example*: #{docs[:examples].map {|ex| '"' + ex + '"'}.join(', ')}"
            end

            response << "*Description*: #{docs[:description]}"
          end.join "\n"
        else
          "I don't know of *#{command}*. Sorry."
        end
      end
    end
  end
end