class QT
  attr_accessor :x,:y,:x_unit,:y_unit
  LEVEL = 9
  MAX_CELLS = lambda {
    temp = []
    (1..LEVEL+1).each do |x|
      temp.push(4 ** x / 3)
    end
  temp
  }.call
def initialize(x,y,w,h)

  @x = x
  @y = y
  @w = w
  @h = h
  self.height= h
  self.width= w
  @x_unit
  @y_unit

  @num_cells = MAX_CELLS[LEVEL]
p MAX_CELLS
  @objs = []
  @latests = []
  @dummy = Entity.new
end

def width=(w)
  @w = w
  @x_unit = ( @w / (1 << LEVEL).prec_f )
#raise "指定範囲が小さすぎます。" 
@x_unit = 1if @x_unit <= 0
end

def height=(h)
  @h = h
  @y_unit = (@h / (1 << LEVEL).prec_f)
#raise "指定範囲が小さすぎます。" 
@y_unit = 1 if @y_unit <= 0
end
def height
  @h
end
def width
  @w
end
def add(obj)
  if(!obj || @objs.index(obj))
    raise "二重登録できません"
  end
  @objs.push(obj)
end
def remove(obj)
  index = objs.index(obj)
  if(index == -1)
     raise "オブジェクトは登録されてません"
  end
end
def removeAll
  objs.size.times{|i| objs[i] = nil}
  @objs = []

end
def simulate

@objs.each{|obj|
index = get_liner_mortonindex(
  obj.x,
  obj.y,
  obj.x + obj.w,
  obj.y + obj.h
)

obj.next = nil

n = index
while(!@latests[n])

  @latests[n] = @dummy
n = (n - 1) >> 2
break if (n >= @num_cells || n < 0)
end

latest = @latests[index]
if(latest != @dummy)
obj.next= latest
end

@latests[index] = obj

}#endwhile

lists = []

if(!@latests[0])
return lists;
end

collide(0, lists, [])

return lists
end

def collide(index,lists,stacks)
 latest = @latests[index]
obj1 = (latest != @dummy)  ? latest : nil
while(obj1)
  obj2 = obj1.next
  while(obj2)
    lists.push(obj1, obj2)
    obj2 = obj2.next
  end
  stacks.each_with_index{|bb,i|

    lists.push(obj1, stacks[i])
  }
 obj1 = obj1.next
end#endwhile

is_child = false
child_index = 0

(0...4).each{|ii|

next_index = index * 4 + 1 + ii

if(next_index < @num_cells && @latests[next_index])
  if(! is_child)
    latest = @latests[index]
    obj1 = (latest != @dummy) ? latest : nil
    while(obj1)

      stacks.push(obj1)

      child_index = child_index + 1
      obj1 = obj1.next
    end
  end
  is_child = true
  collide(next_index, lists, stacks)
end#endif

}#endfor
if(is_child)
(0..child_index).each{|x|
stacks.pop
}
end#endif


end#endcollide



def get_liner_mortonindex(leftX,topY,rightX,bottomY)
lt = get_morton_point(leftX,topY)
rb = get_morton_point(rightX,bottomY)

if(lt >= @num_cells || rb >= @num_cells)
raise "四分木空間の領域外が指定されています"
end

n = rb ^ lt
num_shift = 0

(0...LEVEL).each{|iii|
  if( (n >> (iii * 2) & 0x3).prec_i > 0)
    num_shift = iii + 1
  end
}

index = rb >> (num_shift * 2)
index += MAX_CELLS[LEVEL - (num_shift + 1)]
return (index < @num_cells) ? index : 0xFFFFFF

end#enddef

def get_morton_point(x,y)

bx = to_32bit( ((x - @x).prec_i / @x_unit).prec_i )
by = to_32bit( ((y - @y).prec_i / @y_unit).prec_i )
bx | (by << 1)
end
def to_32bit(n)
  n = (n | (n << 8)) & 0x00FF00FF
  n = (n | (n << 4)) & 0x0F0F0F0F
  n = (n | (n << 2)) & 0x33333333
  (n | (n << 1)) & 0x55555555
end


end


  class Entity
attr_accessor :data,:x,:y,:w,:h,:next
    @data
    @x
    @y
    @w
    @h
    @next
    def initialize(data = nil,x = 0, y = 0,w = 0, h =0 )
      @data = data
      @x = x
      @y = y
      @h = h
      @w = w
    end
    def to_str
      "object QTobject#{@data}"
      end
    end
=begin
qt = QT.new(-20,-20,640+40,360+40)
#puts qt.y_unit
#puts qt.get_morton_point(20, 30)
#puts qt.to_32bit(100)
qt.add(Entity.new("aa",20,30,3,3))
qt.add(Entity.new("aa",200,200,1,1))
qt.add(Entity.new("aa",100,15,5,5))
qt.add(Entity.new("aa",34,23,7,7))

#qt.add(Entity.new("aa",50,50,50,50))
#qt.add(Entity.new("aa",100,120,10,10))
#qt.add(Entity.new("aa",500,500,1,1))
(1..20).each{|x|
  qt.add(Entity.new("aa",rand(640),rand(360),1,1))
}

#p qt.get_morton_point(100,100)
#p qt.get_liner_mortonindex(100,100,100+ 10,100+10)
#(1..20).each{|x|
#qt.simulate
#}
#p qt.simulate.size
=end