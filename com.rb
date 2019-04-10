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
    cell_score = {-9999999999 => [[0,0]]}
    putable_cells = board.get_putable_cells(@color)
    print(cell_list(putable_cells), "\n")
    putable_cells.each do |cell|
      print(COL_NUM.key(cell[1]) + ROW_NUM.key(cell[0]), ": ", BOARD_SCORE[cell[0]][cell[1]], "\n")
      score = BOARD_SCORE[cell[0]][cell[1]]
      if score > cell_score.keys.last
        cell_score[score] = [cell]
      elsif score == cell_score.keys.last
        cell_score[score].push(cell)
      end
    end
    put_cell = select_com_move(cell_score)
    return put_cell
  end

  def cell_list(putable_cells)
    cell_list = "" #着手可能場所の一覧
    putable_cells.each do |cell|
      cell_list += "(" + COL_NUM.key(cell[1]) + ROW_NUM.key(cell[0]) + ")"
    end
    return cell_list
  end

  def select_com_move(cell_score)
    score = cell_score.keys.last
    cell = cell_score[score]
    cell = cell.sample
    return cell
  end
end
