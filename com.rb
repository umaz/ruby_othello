require "./constant"
require "./player"

class Com < Player
  def initialize(color, lv)
    super(color) #親クラスのメソッド呼び出し
    @lv = lv
  end

  def put_stone(board, turn)
    case @lv
    when 1
      cell = lv1(board)
    when 2
      cell = lv2(board)
    when 3
      cell = lv3(board)
    when 4
      cell = lv4(board)
    when 5
      cell = lv5(board)
    end
    row = ROW_NUM.key(cell[0])
    col = COL_NUM.key(cell[1])
    move = col + row
    print(turn, "手目: ", move)
    return cell
  end

  private
  def lv1(board)
    putable_cells = board.get_putable_cells(@color)
    print(cell_list(putable_cells), "\n")
    put_cell = putable_cells.sample #空きますからランダムに1つ取得
    return put_cell
  end

  #BOARD_SCOREのもっとも大きくなるマスに石を打つ
  def lv2(board)
    max_score = -9999999999
    candicate_cells = [[0,0]]
    putable_cells = board.get_putable_cells(@color)
    print(cell_list(putable_cells), "\n")
    putable_cells.each do |cell|
      print(COL_NUM.key(cell[1]) + ROW_NUM.key(cell[0]), ": ", BOARD_SCORE[cell[0]][cell[1]], "\n")
      score = BOARD_SCORE[cell[0]][cell[1]]
      if score > max_score
        candicate_cells = [cell]
        max_score = score
      elsif score == max_score
        candicate_cells.push(cell)
      end
    end
    put_cell = select_com_move(candicate_cells)
    return put_cell
  end

  def lv3(board)
    max_score = -9999999999
    candicate_cells = [[0,0]]
    putable_cells = board.get_putable_cells(@color)
    print(cell_list(putable_cells), "\n")
    putable_cells.each do |cell|
      undo = board.board.map(&:dup) #深いコピー
      board.reverse(cell[0], cell[1], @color)
      score = 0
      board.board.each_with_index do |row, i|
        row.each_with_index do |col, j|
          if col == @color
            score += BOARD_SCORE[i][j]
          end
        end
      end
      print(COL_NUM.key(cell[1]) + ROW_NUM.key(cell[0]), ": ", score, "\n")
      board.undo(undo)
      if score > max_score
        candicate_cells = [cell]
        max_score = score
      elsif score == max_score
        candicate_cells.push(cell)
      end
    end
    put_cell = select_com_move(candicate_cells)
    return put_cell
  end

  def cell_list(putable_cells)
    cell_list = "" #着手可能場所の一覧
    putable_cells.each do |cell|
      cell_list += "(" + COL_NUM.key(cell[1]) + ROW_NUM.key(cell[0]) + ")"
    end
    return cell_list
  end

  def select_com_move(candicate_cells)
    cell = candicate_cells.sample
    return cell
  end
end
