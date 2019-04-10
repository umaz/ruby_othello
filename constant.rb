
#定数の定義
EMPTY = 0 #空きマス
BLACK = 1 #黒石のマス
WHITE = -1 #白石のマス
WALL = 2 #番兵(ひっくり返すときに使う)

ROW_NUM = {"1" => 1, "2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8} #行番号
COL_NUM = {"a" => 1, "b" => 2, "c" => 3, "d" => 4, "e" => 5, "f" => 6, "g" => 7, "h" => 8} #列番号
COLOR = {BLACK => "黒", WHITE => "白"}

#ひっくり返す方向
NONE = 0 #= 0000 0000
UPPER_LEFT = 1 #= 0000 0001
UPPER = 2 #= 0000 0010
UPPER_RIGHT = 4 #= 0000 0100
RIGHT = 8 #= 0000 1000
LOWER_RIGHT = 16 #= 0001 0000
LOWER = 32 #= 0010 0000
LOWER_LEFT = 64 #= 0100 0000
LEFT = 128 #= 1000 0000

#結果
MOVE = 1
PASS = 2
FINISH = 3

#モード番号
COM = 1
HUMAN = 2
WATCH = 3
EXIT = 4

#先手後手
FIRST = 1
SECOND = 2