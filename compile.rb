class Tokenizer
  TOKEN_TYPES = [
    [:def, /\bdef\b/],
    [:end, /\bend\b/],
    [:identifier, /\b[a-zA-Z]+\b/],
    [:integer, /\b[0-9]+\b/],
    [:oparen, /\(/],
    [:cparen, /\)/],
    [:coma, /\,/],
  ]

  def initialize(code)
    @code = code
  end

  def tokenize
    tokens = []
    until @code.empty?
      tokens << tokenize_one_token
      @code = @code.strip
    end
    tokens
  end

  def tokenize_one_token
    TOKEN_TYPES.each do |type, re|
      re = /\A(#{re})/
      if @code =~ re
        value = $1
        @code = @code[value.length..-1]
        return Token.new(type, value)
      end
    end
    raise RuntimeError.new("couldn't match token on #{@code.inspect}")
  end
end

class Parser
  def initialize(tokens)
    @tokens = tokens
  end

  def parse
    parse_def
  end

  def parse_def
    consume(:def)
    name = consume(:identifier).value
    arg_names = parse_arg_names
    body = parse_expr
    consume(:end)
    DefNode.new(name, arg_names, body)
  end

  def parse_expr
    if peak(:integer)
      parse_integer
    elsif peak(:identifier) && peak(:oparen, 1)
      parse_call
    else
      parse_var_ref
    end
  end

  def parse_var_ref
    VarRefNode.new(consume(:identifier).value)
  end

  def parse_call
    name = consume(:identifier).value
    arg_exprs = parse_arg_exprs
    CallNode.new(name, arg_exprs)
  end

  def parse_arg_exprs
    consume(:oparen)

    arg_exprs = []

    if !peak(:cparen)
      arg_exprs << parse_expr
      while peak(:coma)
        consume(:coma)
        arg_exprs << parse_expr
      end
    end
    consume(:cparen)
    arg_exprs
  end

  def parse_integer
    IntegerNode.new(consume(:integer).value.to_i)
  end

  def parse_arg_names
    arg_names = []

    consume(:oparen)

    if peak(:identifier)
      arg_names << consume(:identifier).value
      while peak(:coma)
        consume(:coma)
        arg_names << consume(:identifier).value
      end
    end
    consume(:cparen)
    arg_names
  end

  def consume(expected_type)
    token = @tokens.shift
    if token.type == expected_type
      token
    else
      raise RuntimeError.new("expected token type #{expected_type.inspect} but got #{token.type.inspect}")
    end
  end

  def peak(expected_type, offset = 0)
    @tokens.fetch(offset).type == expected_type
  end
end

DefNode = Struct.new(:name, :arg_names, :body)
IntegerNode = Struct.new(:value)
CallNode = Struct.new(:name, :arg_exprs)
VarRefNode = Struct.new(:value)

class Generator
  def generate(node)
    case node
    when DefNode
      "function %s(%s) {return %s};" % [
        node.name,
        node.arg_names.join(","),
        generate(node.body),
      ]
    when CallNode
      "%s(%s)" % [
        node.name,
        node.arg_exprs.map { |expr| generate(expr) }.join(","),
      ]
    when VarRefNode
      node.value
    when IntegerNode
      node.value
    else
      raise RuntimeError.new("undexpected node type: #{node.class}")
    end
  end
end

Token = Struct.new(:type, :value)
tokens = Tokenizer.new(File.read("test.src")).tokenize
tree = Parser.new(tokens).parse
generated = Generator.new.generate(tree)
TEST = "console.log(f(1 ,78));"
RUNTIME = "function add(x, y) {return x + y};"
puts [RUNTIME, generated, TEST].join("\n")
# puts generated
