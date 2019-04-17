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
      # undo = Marshal.load(Marshal.dump(board.board)) これでも可
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

  def lv4(board)
    max_score = -9999999999
    candicate_cells = [[0,0]]
    depth = 3 #先読みの深さ
    color = @color
    putable_cells = board.get_putable_cells(color)
    print(cell_list(putable_cells), "\n")
    putable_cells.each do |cell|
      # undo = Marshal.load(Marshal.dump(board.board)) これでも可
      undo = board.board.map(&:dup) #深いコピー
      board.reverse(cell[0], cell[1], color)
      case status(board, -color, depth)
      when FINISH
        score = board_score(board)
      when PASS
        score = minmax(board, depth-1, color)
      when MOVE
        score = minmax(board, depth-1, -color)
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

  def lv5(board)
    max_score = -9999999999
    alpha = -9999999999
    beta = 9999999999
    candicate_cells = [[0,0]]
    depth = 4 #先読みの深さ
    color = @color
    putable_cells = board.get_putable_cells(color)
    print(cell_list(putable_cells), "\n")
    putable_cells.each do |cell|
      # undo = Marshal.load(Marshal.dump(board.board)) これでも可
      undo = board.board.map(&:dup) #深いコピー
      board.reverse(cell[0], cell[1], color)
      case status(board, -color, depth)
      when FINISH
        score = board_score(board)
      when PASS
        score = alphabeta(board, depth-1, color, alpha, beta)
      when MOVE
        score = alphabeta(board, depth-1, -color, alpha, beta)
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

  def minmax(board, depth, color)
    best_score = 9999
    putable_cells = board.get_putable_cells(color)
    putable_cells.each do |cell|
      undo = board.board.map(&:dup) #深いコピー
      board.reverse(cell[0], cell[1], color)
      case status(board, -color, depth)
      when FINISH
        score = board_score(board)
      when PASS
        score = minmax(board, depth-1, color)
      when MOVE
        score = minmax(board, depth-1, -color)
      end
      board.undo(undo)
      #スコアの選択(αβ法)
      if best_score == 9999
        best_score = score
      end
      if color == @color && score > best_score
        best_score = score
      end
      if color == -@color && score < best_score
        best_score = score
      end
    end
    return best_score
  end

  def alphabeta(board, depth, color, alpha, beta)
    best_score = 9999
    putable_cells = board.get_putable_cells(color)
    putable_cells.each do |cell|
      undo = board.board.map(&:dup) #深いコピー
      board.reverse(cell[0], cell[1], color)
      case status(board, -color, depth)
      when FINISH
        score = board_score(board)
      when PASS
        score = alphabeta(board, depth-1, color, alpha, beta)
      when MOVE
        score = alphabeta(board, depth-1, -color, alpha, beta)
      end
      board.undo(undo)
      #スコアの選択(αβ法)
      if best_score == 9999
        best_score = score
      end
      if color == @color
        if score > best_score
          best_score = score
        end
        if best_score > alpha
          alpha = best_score
        end
        if alpha >= beta
          return best_score
        end
      end
      if color == -@color
        if score < best_score
          best_score = score
        end
        if best_score < beta
          beta = best_score
        end
        if alpha >= beta
          return best_score
        end
      end
    end
    return best_score
  end

  def board_score(board)
    score = 0
    #スコアの算出
    board.board.each_with_index do |row, i|
      row.each_with_index do |col, j|
        if col == @color
          score += BOARD_SCORE[i][j]
        end
      end
    end
    return score
  end

  #状態判定
  def status(board, color, depth)
    if depth == 0
      return FINISH
    else
      if board.get_putable_cells(color).size == 0
        if board.get_putable_cells(-color).size == 0
          return FINISH
        else
          return PASS
        end
      else
        return MOVE
      end
    end
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
