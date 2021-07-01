module ApplicationHelper

  # 半角スペースを指定した回数だけ挿入するメソッド
  def insert_space(roops)   
    space = '' 
    if roops >= 1 
      roops.times do  
        space += '&nbsp;' 
      end 
    end 
   return raw(space) 
 end 

end
