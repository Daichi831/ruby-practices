# frozen_string_literal: true

require 'minitest/autorun'
require_relative './bowling_object'

class TestGame < MiniTest::Unit::TestCase
  def test_score1
    game_score1 = Game.new('6390038273X9180X645')
    assert_equal 139, game_score1.score
  end

  def test_score2
    game_score2 = Game.new('6390038273X9180XXXX')
    assert_equal 164, game_score2.score
  end

  def test_score3
    game_score3 = Game.new('0X150000XXX518104')
    assert_equal 107, game_score3.score
  end

  def test_score4
    game_score4 = Game.new('6390038273X9180XX00')
    assert_equal 134, game_score4.score
  end

  def test_score5
    game_score5 = Game.new('XXXXXXXXXXXX')
    assert_equal 300, game_score5.score
  end
end
