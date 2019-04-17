def hoge(alpha)
  [1,2,3,4,5,6,7,8,9,10].each do |i|
    p alpha
    if i % 2 == 0
      alpha = i
    end
  end
end

hoge(0)