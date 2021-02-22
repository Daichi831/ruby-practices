#! /usr/bin/env ruby
# frozen_string_literal: true

class Game
  def initialize(score_text)
    create_frame(score_text)
  end

  def score
    point = 0
    10.times do |index|
      point += @frames[index].frame_score
      point += calc_bonus_score(index)
    end
    point
  end

  private

  def create_frame(score_text)
    @frames = []
    frame = []

    score_text.chars.each do |s|
      frame << s
      if @frames.size < 9

        if frame.size >= 2 || s == 'X'
          @frames << Frame.new(frame[0], frame[1])
          frame.clear
        end
      end
    end
    # 最終フレームは3投いれる
    @frames << Frame.new(frame[0], frame[1], frame[2])
  end

  def calc_bonus_score(index)
    bonus = 0
    if index == 9
      return 0
    end

    if index == 8 && double_strike?(index)
      return bonus += 10 + @frames[index + 1].shot2.score
    end

    if double_strike?(index)
      return bonus += 10 + @frames[index + 2].shot1.score
    end

    if strike?(index)
      return bonus += @frames[index + 1].shot1.score + @frames[index + 1].shot2.score
    end

    if spare?(index)
      return bonus += @frames[index + 1].shot1.score
    end
    bonus
  end

  def strike?(index)
    @frames[index].shot1.mark == 'X'
  end

  def double_strike?(index)
    @frames[index].shot1.mark == 'X' && @frames[index + 1].shot1.mark == 'X'
  end

  def spare?(index)
    @frames[index].shot1.score + @frames[index].shot2.score == 10
  end

end

class Frame
  attr_reader :shot1, :shot2, :shot3

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @shot1 = Shot.new(first_mark)
    @shot2 = Shot.new(second_mark)
    @shot3 = Shot.new(third_mark)
  end

  def frame_score
    [shot1.score, shot2.score, shot3.score].sum
  end
end

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def score
    mark == 'X' ? 10 : mark.to_i
  end
end

game = Game.new(ARGV[0])
puts game.score
