require 'strscan'

module JsVariableParser
  class JsVariableParser

    attr_accessor :variables, :functions

    # @param {String} js JavaScript code as string
    def initialize(js)
      @buffer = StringScanner.new(js)
      @variables = []
      @functions = []
      parse
    end

    def parse
      # Parse until end
      until @buffer.eos?
        # Skip ""
        skip_quote_closure("\"")
        # Skip ''
        skip_quote_closure("'")
        # Skip ``
        # String format literal is not Supported
        # eg. `this is a ${penName}` is not supported
        skip_quote_closure("`")

        # Skip [] space comma...
        @buffer.skip(/[^a-zA-Z0-9\.]/)

        # Parse variable from code
        parse_variable
      end
    end

    def parse_variable
      # Examples:
      # Detect moment().format('YYYY-MM-DD')
      # Detect hogeNumber
      # Detect hoge2
      # Skip .hoge
      # Skip 2hoge
      # Skip 123 123.123
      variable = @buffer.scan(/[a-zA-Z]+[\w\d]*/)

      # Allow .format('YYYY-MM-DD')
      # Allow .format(formatString)
      # Skip format()
      chainedFunction = @buffer.scan(/\.[a-zA-Z]+[\w\d]*/)

      # Skip 123
      # Skip 123.123
      number = @buffer.scan(/[0-9\.]+/)

      if variable
        # Erase method chains and remove function call
        variable = variable.split('.').first.match(/[a-zA-Z]+\w*/)[0]
        @variables << variable
      end

      if chainedFunction
        @functions << chainedFunction
      end
    end

    def skip_quote_closure quote
      # Detect start
      if @buffer.peek(1) == "#{quote}"
        @buffer.getch
        # Find end
        matches = @buffer.scan_until(/#{quote}/)
        unless matches
          raise StandardError.new("Quotes not balanced. Ecpected )")
        end
      end
    end

  end
end
