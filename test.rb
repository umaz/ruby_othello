class Hoge
  def initialize
    @color = 1
  end

  def hoge
    color = @color
    color = -color
    p color
    p @color
  end
end

Hoge.new.hoge