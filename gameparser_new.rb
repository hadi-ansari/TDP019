# coding: utf-8
require './rdparse.rb'
require './classparser'

class GameLanguage

  def initialize
    @gameParser = Parser.new("game language") do
      @user_assignments = {}
      
      
      token(/#.*/) #removes comment
      token(/\s+/) #removes whitespaces
      token(/^\d+/) {|m| m.to_i} #returns integers
      token(/\w+/) {|m| m } #returns variable names as string
      token(/".*?"/) do |m|
        m = m[1...-1]
        LiteralString.new(m)
      end #returns a LiteralString object
       token(/'.*?'/) do |m|
        m = m[1...-1]
        obj = LiteralString.new(m)
      end #returns string a LiteralString object
      token(/./) {|m| m } #returns rest like (, {, =, < etc as string
      
      start :prog do
        match(:comps) {|m| m }
      end

      rule :comps do
        match(:comps, :comp) {|m| m }
        match(:comp) {|m| m }
      end

      rule :comp do
        match(:definition) {|m| m }
        match(:statement) {|m| m }
      end

      rule :definition do
        match(:type)
        match(:event)
      end

      rule :statement do
        # match(:function_call)
        match(:condition)
        match(:loop)
        match(:assignment)
        match(:value)
      end

      # rule :function_call do
      #   match(:run)
      #   match(:read?)
      #   match(:write?)
      # end

      # rule :read do
      # end

      # rule :write do
      # end

      # rule :type do
      #   match("type", String, "{", :assignsments, :run,"}")
      # end

      # rule :event do
      #   match("event", String, "{", :assignsments, :run,"}")
      # end

      rule :assignsments do
        match(:assignsments, :assignment)
        match(:assignment)
      end

      rule :assignment do
        match(:var, "=", :value) { |m,  _, n| @user_assignments[m] = n}
      end

      rule :exp do
        match(:log_exp) {|e| e}
        match(:math_exp) {|e| e}
      end

      rule :values do
        match(:values, ",", :value) {|m, _, n| m + Array(n)}
        match(:value) {|m| Array(m)}
      end

      rule :value do
        match(LiteralString) {|s| s.str }
        match(:array) {|a| a}
        match(:exp) {|e| e}
      end

      rule :array do
        match("[", :values, "]") {|_, v, _| v}
        match("[", "]") {[]}
      end

      rule :run do
        match("run", "(""example.rb", :block_comps, ")")
      end

      rule :loop do
        match(:while)
        match(:for)
      end

      rule :condition do
        match(:if)
        match(:switch)
      end

      rule :while do
        match("while", :log_exp, "{", :block_comps, "}")
      end

      rule :if do
        match("if", :log_exp, "{", :block_comps, "}", "else", "{", :block_comps, "}")
        match("if", :log_exp, "{", :block_comps, "}")
      end

      rule :switch do
        match("case", :var, :cases)
      end

      rule :cases do
        match(:cases, :case)
        match(:case)
      end

      rule :case do
        match()
      end

      rule :for do
        match("for", :var, "in", :array, "{", :block_comps, "}")
      end

      rule :log_exp do
        match(:bool_exp, "and", :log_exp) {|m, _, n| m and n}
        match(:bool_exp, "or", :log_exp) {|m, _, n| m or n}
        match("not", :log_exp) {|_, m, _| !m}
        match(:bool_exp) {|m| m}
      end

      rule :bool_exp do
        match(:math_exp, "<", :math_exp) {|m, _, n| m < n}
        match(:math_exp, "<", "=", :math_exp) {|m, _, _, n| m <= n}
        match(:bool_val, "=", "=", :bool_val) {|m, _, _, n| m == n}
        match(:math_exp, "=", "=", :math_exp) {|m, _, _, n| m == n}
        match(:math_exp, ">", :math_exp) {|m, _, n| m > n}
        match(:math_exp, ">", "=", :math_exp) {|m, _, _, n| m >= n}
        match(:math_exp, "!", "=", :math_exp) {|m, _, _, n| m != n}
        match(:bool_val, "!", "=", :bool_val) {|m, _, _, n| m != n}
        match(:bool_val) {|m| m}
        match(:var) {|m| @user_assignments[m]}
        end

      rule :bool_val do
        match("true") {true}
        match("false") {false}
        match("(", :log_exp, ")") {|_, m, _| m } 
      end

      rule :math_exp do
        match(:math_exp, "+", :term) {|m, _, n| m + n}
        match(:math_exp, "-", :term) {|m, _, n| m - n}
        match(:term) {|m| m}
      end

      rule :term do
        match(:term, "*", :factor) {|m, _, n| m * n}
        match(:term, "/", :factor) {|m, _, n| m / n}
        match(:factor) {|m| m}
      end

      rule :factor do
        match(Integer) {|m| m}
        match("-", Integer) {|_, m| -m}
        match("+", Integer) {|_, m| m}
        match("(", :math_exp , ")"){|_, m, _| m}
        match(:var) {|m| @user_assignments[m]}
      end

      rule :var do
        match(String) {|s| s}
      end
    end

# ============================================================
# Parser end
# ============================================================


    def done(str)
      ["quit","exit","bye",""].include?(str.chomp)
    end
    def parse_string(str)
      log(false)
      @gameParser.parse(str)
    end
    def parse()
      print "[gameParser] "
      #str = File.read(file)
      str = gets
      if done(str) then
        puts "Bye."
      else
        puts "=> #{@gameParser.parse str}"
        parse
      end
    end

    def log(state = true)
      if state
        @gameParser.logger.level = Logger::DEBUG
      else
        @gameParser.logger.level = Logger::WARN
      end
    end
  end
end

if __FILE__ == $0
  GameLanguage.new.parse()  
end