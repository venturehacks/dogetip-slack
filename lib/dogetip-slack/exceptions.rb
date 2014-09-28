module DogetipSlack
  class DogeError < StandardError; end

  # Raised when the given command isn't found
  class CommandNotFound < DogeError
    def initialize(bad_command)
      super "*#{bad_command}* is not a known command. Try *help* to get a list of commands. Wow."
    end
  end

  # Raised when any unanticipated exception occurs within a command (ruby errors, etc.)
  class CommandError < DogeError
    def initialize(exception)
      puts exception.class.to_s + ": " + exception.message
      puts exception.backtrace.join "\n"
      super "Very oops: *#{exception.message}*. Much logged. So sorry. Wow."
    end
  end

  class UnknownUser < DogeError
    def initialize(username = nil)
      if username.nil?
        super "I don't know you well enough! Please use the *introduce* command in a channel."
      else
        super "I don't know who _@#{username}_ is. Please use the *introduce* command in a channel."
      end
    end
  end

  class InsufficientFunds < DogeError
    def initialize
      super "You do not have the funds for that!"
    end
  end

  class BadArgument < DogeError
    def initialize(argument)
      super "_#{argument}_ is either missing or invalid. Please try again."
    end
  end

  class PrivateCommand < DogeError
    def initialize
      super "This command can only be used in a private message to the bot."
    end
  end

  class PublicCommand < DogeError
    def initialize
      super "This command can only be used in a public channel."
    end
  end
end