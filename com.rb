require "./constant"
require "./player"

class Com < Player
  def initialize(color, lv)
    super(color) #親クラスのメソッド呼び出し
    @lv = lv
  end

  def put_stone(putable_cells)
    print(cell_list(putable_cells), "\n")
    put_cell = putable_cells.sample #空きますからランダムに1つ取得
    return put_cell
  end

  private
  def cell_list(putable_cells)
    cell_list = "" #着手可能場所の一覧
    putable_cells.each do |cell|
      cell_list += "(" + COL_NUM.key(cell[1]) + ROW_NUM.key(cell[0]) + ")"
    end
    return cell_list
  end
end
