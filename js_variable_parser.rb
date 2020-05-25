require 'strscan'

class JSVariableParser

  attr_accessor :variables

  # @param {String} js JavaScript code as string
  def initialize(js)
    @buffer = StringScanner.new(js)
    @variables = []
    parse
  end

  def parse
    # Parse until end
    until @buffer.eos?
      # Skip ()
      skip_kakko
      # Skip ""
      skip_quote_closure("\"")
      # Skip ''
      skip_quote_closure("'")
      # Skip ``
      skip_quote_closure("`")
      
      # Skip [] space comma...
      @buffer.skip(/[\W]/)

      # Parse variable from code
      parse_variable
    end
  end

  def parse_variable
    # Examples: 
    # Allow moment().format('YYYY-MM-DD')
    # Allow hogeNumber
    # Allow hoge2
    # Disallow 2hoge
    # Disallow 123 123.123
    variable = @buffer.scan(/[a-zA-Z]+[\w\d\.\(\)\'\"\-\_]*/)
    
    # Skip 123
    # Skip 123.123
    number = @buffer.scan(/[0-9\.]+/)

    if variable
      # Erase method chains and remove function call
      variable = variable.split('.').first.match(/[a-zA-Z]+\w*/)[0]
      @variables << variable
    end
  end

  def skip_kakko
    # Detect start (
    if @buffer.peek(1) == "("
      @buffer.getch
      # Find end
      @buffer.scan_until(/\)/)
    end
  end

  def skip_quote_closure quote
    # Detect start
    if @buffer.peek(1) == "#{quote}"
      @buffer.getch
      # Find end
      @buffer.scan_until(/#{quote}/)
    end
  end

end
