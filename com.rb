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
    when 6
      cell = lv6(board, turn)
    when 7
      cell = lv7(board, turn)
    when 8
      cell = lv8(board, turn)
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
    best_score = -9999999999
    candicate_cells = [[0,0]]
    putable_cells = board.get_putable_cells(@color)
    print(cell_list(putable_cells), "\n")
    putable_cells.each do |cell|
      print(COL_NUM.key(cell[1]) + ROW_NUM.key(cell[0]), ": ", BOARD_SCORE[cell[0]][cell[1]], "\n")
      score = BOARD_SCORE[cell[0]][cell[1]]
      if score > best_score
        candicate_cells = [cell]
        best_score = score
      elsif score == best_score
        candicate_cells.push(cell)
      end
    end
    put_cell = select_com_move(candicate_cells)
    return put_cell
  end

  def lv3(board)
    best_score = -9999999999
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
      if score > best_score
        candicate_cells = [cell]
        best_score = score
      elsif score == best_score
        candicate_cells.push(cell)
      end
    end
    put_cell = select_com_move(candicate_cells)
    return put_cell
  end

  def lv4(board)
    best_score = -9999999999
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
      if score > best_score
        candicate_cells = [cell]
        best_score = score
      elsif score == best_score
        candicate_cells.push(cell)
      end
    end
    put_cell = select_com_move(candicate_cells)
    return put_cell
  end

  def lv5(board)
    best_score = -9999999999
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
        score = alphabeta(board, depth-1, color, alpha, beta, BOARD)
      when MOVE
        score = alphabeta(board, depth-1, -color, alpha, beta, BOARD)
      end
      print(COL_NUM.key(cell[1]) + ROW_NUM.key(cell[0]), ": ", score, "\n")
      board.undo(undo)
      if score > best_score
        candicate_cells = [cell]
        best_score = score
      elsif score == best_score
        candicate_cells.push(cell)
      end
    end
    put_cell = select_com_move(candicate_cells)
    return put_cell
  end

  def lv6(board, turn)
    best_score = -9999999999
    alpha = -9999999999
    beta = 9999999999
    candicate_cells = [[0,0]]
    depth = 4 #先読みの深さ
    if turn > 49
      type = PERFECT
      depth = -1
    else
      type = BOARD
    end
  color = @color
    putable_cells = board.get_putable_cells(color)
    print(cell_list(putable_cells), "\n")
    putable_cells.each do |cell|
      # undo = Marshal.load(Marshal.dump(board.board)) これでも可
      undo = board.board.map(&:dup) #深いコピー
      board.reverse(cell[0], cell[1], color)
      case status(board, -color, depth)
      when FINISH
        score = perfect_score(board)
      when PASS
        score = alphabeta(board, depth-1, color, alpha, beta, type)
      when MOVE
        score = alphabeta(board, depth-1, -color, alpha, beta, type)
      end
      print(COL_NUM.key(cell[1]) + ROW_NUM.key(cell[0]), ": ", score, "\n")
      board.undo(undo)
      if score > best_score
        candicate_cells = [cell]
        best_score = score
      elsif score == best_score
        candicate_cells.push(cell)
      end
    end
    put_cell = select_com_move(candicate_cells)
    return put_cell
  end

  def lv7(board, turn)
    best_score = -9999999999
    alpha = -9999999999
    beta = 9999999999
    candicate_cells = [[0,0]]
    depth = -1 #先読みの深さ
    color = @color
    if turn > 49
      type = PERFECT
    elsif turn > 47
      type = WINNER
    else
      type = BOARD
      depth = 4
    end
    putable_cells = board.get_putable_cells(color)
    print(cell_list(putable_cells), "\n")
    putable_cells.each do |cell|
      # undo = Marshal.load(Marshal.dump(board.board)) これでも可
      undo = board.board.map(&:dup) #深いコピー
      board.reverse(cell[0], cell[1], color)
      case status(board, -color, depth)
      when FINISH
        score = perfect_score(board)
      when PASS
        score = alphabeta(board, depth-1, color, alpha, beta, type)
      when MOVE
        score = alphabeta(board, depth-1, -color, alpha, beta, type)
      end
      print(COL_NUM.key(cell[1]) + ROW_NUM.key(cell[0]), ": ", score, "\n")
      board.undo(undo)
      if score > best_score
        candicate_cells = [cell]
        best_score = score
      elsif score == best_score
        candicate_cells.push(cell)
      end
    end
    put_cell = select_com_move(candicate_cells)
    return put_cell
  end

  def lv8(board, turn)
    best_score = -9999999999
    alpha = -9999999999
    beta = 9999999999
    candicate_cells = [[0,0]]
    depth = -1 #先読みの深さ
    color = @color
    if turn > 49
      type = PERFECT
    elsif turn > 47
      type = WINNER
    else
      type = HANDS
      depth = 4
    end
    putable_cells = board.get_putable_cells(color)
    print(cell_list(putable_cells), "\n")
    putable_cells.each do |cell|
      # undo = Marshal.load(Marshal.dump(board.board)) これでも可
      undo = board.board.map(&:dup) #深いコピー
      board.reverse(cell[0], cell[1], color)
      case status(board, -color, depth)
      when FINISH
        score = perfect_score(board)
      when PASS
        score = alphabeta(board, depth-1, color, alpha, beta, type)
      when MOVE
        score = alphabeta(board, depth-1, -color, alpha, beta, type)
      end
      print(COL_NUM.key(cell[1]) + ROW_NUM.key(cell[0]), ": ", score, "\n")
      board.undo(undo)
      if score > best_score
        candicate_cells = [cell]
        best_score = score
      elsif score == best_score
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

  def alphabeta(board, depth, color, alpha, beta, type)
    best_score = 9999
    putable_cells = board.get_putable_cells(color)
    putable_cells.each do |cell|
      undo = board.board.map(&:dup) #深いコピー
      board.reverse(cell[0], cell[1], color)
      case status(board, -color, depth)
      when FINISH
        case type
        when PERFECT
          score = perfect_score(board)
        when WINNER
          score = winner_score(board)
        when BOARD
          score = board_score(board)
        when HANDS
          score = board_score(board)
          if color == @color
            score += 10 * putable_cells.size
          else
            score -= 10 * putable_cells.size
          end
        end
      when PASS
        score = alphabeta(board, depth-1, color, alpha, beta, type)
      when MOVE
        score = alphabeta(board, depth-1, -color, alpha, beta, type)
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
          return alpha
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
          return beta
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

  def winner_score(board)
    #スコアの算出
    result = board.count
    score = @color * (result[0] - result[1]) #石差
    if score > 0
      return 1
    elsif score < 0
      return -1
    else
      return 0
    end
  end

  def perfect_score(board)
    #スコアの算出
    result = board.count
    score = @color * (result[0] - result[1]) #石差
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
