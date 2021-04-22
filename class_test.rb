# coding: utf-8
require './gameparser'
require 'test/unit'

class EventTest < Test::Unit::TestCase
  def test1()
    gp = GameLanguage.new()

    code = 'write("Expecting 2")
            event Test { init { i = 2 } run { write(i) } }
            load(Test)'

    assert_equal(nil, gp.parse_string(code))
  end

  def test2()
    gp = GameLanguage.new()

    code1 = 'write("Expecting 2")
            event Test
            {
              init
               {
                  i = 2
               }
             run
              {
                 write(i)
                 i = 5

              }
             }
            load(Test)'
    assert_equal(nil, gp.parse_string(code1))


    code2 = 'write("Expecting 5")
             load(Test)'

    assert_equal(nil, gp.parse_string(code2))
  end

  def test3()
    gp = GameLanguage.new()

    code1 = 'write("Expecting 5")
            event Test
            {
              init
               {
                  i = 0
                  for k in (1..5)
                    {
                      i = i + 1
                    }
               }
             run
              {
                 write(i)
                 i = 33

              }
             }
            load(Test)'
    assert_equal(nil, gp.parse_string(code1))


    code2 = 'write("Expecting 33")
             load(Test)'

    assert_equal(nil, gp.parse_string(code2))
  end

end