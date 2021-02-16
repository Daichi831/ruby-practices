#! /usr/bin/env ruby
# frozen_string_literal: true

class Game
  def initialize(score_text)
    create_frame(score_text)
  end

  def create_frame(score_text)
    @frames = []
    frame = []

    score_text.chars.each do |s|
      frame << s
      next unless @frames.size < 9

      if frame.size >= 2 || s == 'X'
        @frames << Frame.new(frame[0], frame[1])
        frame.clear
      end
    end
    # 最終フレームは3投いれる
    @frames << Frame.new(frame[0], frame[1], frame[2])
  end

  # フレームごとの通常スコア
  def calc_frame_score(num)
    target_frame = @frames[num]
    target_frame.frame_score
  end

  def strike?(num)
    @frames[num].first_shot.mark == 'X'
  end

  def next_strike?(num)
    @frames[num + 1].first_shot.mark == 'X'
  end

  def supea?(num)
    @frames[num].first_shot.score + @frames[num].second_shot.score == 10
  end

  # 全てのフレームの合計
  def score
    point = 0
    10.times.each do |num|
      point += calc_frame_score(num)
      point += calc_bonus_score(num)
    end
    point
  end

  # ボーナス得点の計算
  def calc_bonus_score(num)
    bonus = 0
    if num == 9
      bonus += 0
    elsif num == 8 && strike?(num) && next_strike?(num)
      bonus += 10 + @frames[num + 1].second_shot.score

    elsif strike?(num) && next_strike?(num)
      bonus += 10 + @frames[num + 2].first_shot.score

    elsif strike?(num)
      bonus += @frames[num + 1].first_shot.score + @frames[num + 1].second_shot.score

    elsif supea?(num)
      bonus += @frames[num + 1].first_shot.score
    end
    bonus
  end
end

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark = nil, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  # ボーナス加点を含まないフレームごとのスコア
  def frame_score
    [first_shot.score, second_shot.score, third_shot.score].sum
  end
end

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  # 文字列を整数に変換
  def score
    return 10 if mark == 'X'

    mark.to_i
  end
end

game = Game.new(ARGV[0])
p game.score
