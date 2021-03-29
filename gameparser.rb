load "./rdparse.rb"

class GameLanguage

  def initialize
    @gameParser = Parser.new("game language") do
      @user_assignments = {}

      token(/#.*/) #removes comment
      token(/\s+/) #removes whitespaces
      #warrior1 = 22
      token(/^[-+]?\d+$/) {|m| m.to_i}
      token(/\w+/) {|m| m } #returns chars
      token(/./) {|m| m } #returns rest

      start :prog do
        match(:comps) {|m| m }
      end

      rule :comps do
        match(:comp, :comps) {|m| m }
        match(:comp) {|m| m }
      end

      rule :comp do
        match(:type) {|m| m }
        match(:block_comp) {|m| m }
      end

      rule :block_comp do
        match(:function) {|m| m }
        match(:cond_exp) {|m| m }
        match(:loop) {|m| m }
        match(:assignment) {|m| m }
        match("") # hur matchar vi Empty?
      end

      rule :function do
        match(:run)
        match(:read?)
        match(:write?)
      end

      rule :read do
      end

      rule :write do
      end

      rule :type do
        match(:event)
        match(:object)
      end

      rule :event do
        match("event", String, "{", :assignsments, :run,"}")
      end

      rule :assignsments do
        match(:assignsments, :assignment)
        match(:assignment)
      end

      rule :assignment do
        match(:var, "=", :value) { |m,  _, n| @user_assignments[m] = n}
      end

      rule :run do
        match("run", "(", :block_comps, ")")
      end

      rule :var do
        match(String) {|s| s}
      end

      rule :values do
        match(:values, :value)
        match(:value)
      end
      var = "Hadi"
      var2 = "1234"
      rule :value do
        match(String){|s|
          x = Integer(s) resque false
          if x
            x
          else
            s
          end
        end
        }
        #match(Integer){|i| i}
        match(:bool_val){|b| b}
        match(:array)
        match(:function_call)

      end

      rule :array do
        match("[", :values, "]")
        match("[", "]")
      end

      rule :object do
        match(:assignsments)
      end

      rule :loop do
        match(:while)
        match(:for)
      end

      rule :cond_exp do
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

      rule :for do
        match("for", :var, "in", :array, "{", :block_comps, "}")
      end

      rule :log_exp do
        match(:bool_exp, "and", :log_exp)
        match(:bool_exp, "or", :log_exp)
        match(:bool_exp)
      end
      rule :bool_exp do
        match(:math_exp, "<", :math_exp)
        match(:math_exp, "<=", :math_exp)
        match(:math_exp, "==", :math_exp)
        match(:math_exp, ">", :math_exp)
        match(:math_exp, ">=", :math_exp)
        match(:math_exp, "!=", :math_exp)
        match(:bool_val)
        match(:var)
      end
      rule :bool_val do
        match("True") {True}
        match("False") {False}
      end

      rule :math_exp do
        match(:math_exp, "+", :term)
        match(:math_exp, "-", :term)
        match(:term)
      end

      rule :term do
        match(:term, "*", :factor)
        match(:term, "/", :factor)
        match(:factor)
      end

      rule :factor do
        match(Integer, :var)
      end
    end

    def done(str)
      ["quit","exit","bye",""].include?(str.chomp)
    end

    def roll(file)
      print "[gameParser]"
      str = File.read(file)
      if done(str) then
        puts "Bye."
      else
        puts "=> #{@gameParser.parse str}"
        roll
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

GameLanguage.new.roll("example.rb")