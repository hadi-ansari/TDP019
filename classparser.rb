#!/usr/bin/env ruby
# coding: utf-8

#require "rdparse"

class Prog
  def initialize(comps)
    @comps = comps
  end

  def evaluate()
    return @comps.evaluate()
  end
end

class Comps
  def initialize(comps, comp)
    @comps = comps
    @comp = comp
  end

  def evaluate()
    if @comps != nil
      return @comps.evaluate(), @comp.evaluate()
    else
      return @comp.evaluate()
    end
  end
end

class Comp
  def initialize(comp)
    @comp = comp
  end

  def evaluate()
    return @comp.evaluate()
  end
end

class Definition
  def initialize(object)
    @object = object
  end

  def evaluate()
    nil
  end
end

class Statement
  def initialize(object)
    @object = object
  end

  def evaluate()
    return @object.evaluate()
  end
end

class Assignment
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    @lhs = @rhs.evaluate()
    #puts @lhs
    return @lhs
  end
end

class Value
  def initialize(object)
    @object = object
  end

  def evaluate()
    return @object.evaluate()
  end
end

class Arry
  def initialize(list)
    @list = list
  end

  def evaluate()
    result_list = []

    for element in @list
      result_list << element.evaluate()
    end

    return result_list
  end
end

class And
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return (@lhs.evaluate() and @rhs.evaluate())
  end
end

class Or
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return (@lhs.evaluate() or @rhs.evaluate())
  end
end

class Not
  def initialize(object)
    @object = object
  end

  def evaluate()
    return (not @object.evaluate())
  end
end

class Less
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() < @rhs.evaluate()
  end
end

class LessEqual
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() <= @rhs.evaluate()
  end
end

class Greater
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() > @rhs.evaluate()
  end
end

class GreaterEqual
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() >= @rhs.evaluate()
  end

end


class Equal
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() == @rhs.evaluate()
  end

end

class NotEqual
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() != @rhs.evaluate()
  end

end

class Addition
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() + @rhs.evaluate()
  end

end

class Subtraction
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs
  end

  def evaluate()
    return @lhs.evaluate() - @rhs.evaluate()
  end

end

class Multiplication
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs

  end

  def evaluate()
    return @lhs.evaluate() * @rhs.evaluate()
  end

end

class Division
  def initialize(lhs, rhs)
    @lhs = lhs
    @rhs = rhs

  end

  def evaluate()
    return @lhs.evaluate() / @rhs.evaluate()
  end

end

class LiteralBool
  def initialize(value)
    if value == "true"
      @value = true
    else
      @value = false
    end

  end

  def evaluate()
    return @value
  end

end

class LiteralInteger
  def initialize(value)
    @value = value

  end

  def evaluate()
    return @value
  end

end

class LiteralString
  attr_accessor :str
  def initialize(st)
    @str = st
  end

  def evaluate()
    return @str
  end
end


class Variable
  def initialize(value)
    @value = value
  end

  def evaluate()
    return @value
  end
end


# def test(i)
#   {
#    k = 5 + i
#    k
#  }
# [i] {"i": 0}
class Function
  def initialize(params, block)
    #puts params
    puts block
    @params_hash = Hash.new
    for i in params
      @params_hash[i] = nil
    end

    @block = block
  end
#{"i": nil}
#[1]
  def evaluate(arguments)
    counter = 0
    @params_hash.each do |k, v|
      @params_hash[k] = arguments[counter]
      counter += 1
    end
    puts @params_hash
    counter = 0
    for object in @block
      m = object.evaluate()
      puts object
      counter += 1
      if counter == @block.length
        puts m
        return m
      end
    end
  end
end
