require_relative "./constant"

class Board
  #新しい盤
  def initialize
    #盤面を表す二重配列の作成
    @board = [
      [WALL,WALL,WALL,WALL,WALL,WALL,WALL,WALL,WALL,WALL], 
      [WALL,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,WALL], 
      [WALL,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,WALL], 
      [WALL,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,WALL], 
      [WALL,EMPTY,EMPTY,EMPTY,WHITE,BLACK,EMPTY,EMPTY,EMPTY,WALL], 
      [WALL,EMPTY,EMPTY,EMPTY,BLACK,WHITE,EMPTY,EMPTY,EMPTY,WALL], 
      [WALL,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,WALL], 
      [WALL,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,WALL], 
      [WALL,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,EMPTY,WALL], 
      [WALL,WALL,WALL,WALL,WALL,WALL,WALL,WALL,WALL,WALL]
    ]
  end

  attr_reader :board

  #現在の盤の状態を表示
  def show_board
    print("\n\n  #{COL_NUM.keys.join(" ")}") #列
    @board.each_with_index do |row, i| #番兵を除く
      print(ROW_NUM[(i).to_s])
      row.each do |col|
        case col
        when EMPTY
          print "\e[32m"
          print(" □")
          print "\e[0m"
        when BLACK
          print(" ○")
        when WHITE
          print(" ●")
        end
      end
      print("\n")
    end
    print("\n")
    stone_count = count
    print("\n 黒:#{stone_count[0]}, 白:#{stone_count[1]}\n\n")
  end

  private
  #石の数のカウント
  def count
    black = 0
    white = 0
    @board.each do |row|
      row.each do |col|
        case col
        when BLACK
          black += 1
        when WHITE
          white += 1
        end
      end
    end
    count = [black, white]
    return count
  end
end
Board.new.show_board