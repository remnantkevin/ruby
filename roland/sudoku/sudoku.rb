# where is processing handled if get from cli or text?

class Sudoku

  attr_accessor :layout, :fixed

  def initialize(layout, fixed)
    @layout = layout
    @fixed = fixed
    print_l
    puts "---"*20
  end

  def get_column(col)
    column_values = []
    9.times {|y| column_values << layout[y][col]}
    return column_values
  end

  def get_block(x, y)
    top_left_x_coord = x/3*3
    top_left_y_coord = y/3*3
    block = []
    3.times do |i|
      3.times do |j|
        block << layout[top_left_y_coord+i][top_left_x_coord+j]
      end
    end
    return block
  end

  def check(x, y, n)
    if layout[y].include?(n)
      false
    elsif get_column(x).include?(n)
      false
    elsif get_block(x, y).include?(n)
      false
    else
      true
    end
  end

  # find next cell that's not a fixed cell or beyond the boundaries
  # the highest x,y position this get's called at is y==4 && x==3
  def next_cell(x, y)
    if x == 8 && y == 8 # i know this is a poor way to know stop solving the sudoku
      print_l
      puts "fin"
      exit
    elsif x == 8
      i = 0 # previous x
      j = y + 1 # previous y
      while fixed.include?([j,i]) # is the previous cell in the fixed cell list?
        i, j = next_cell(i, j)
      end
      return i, j
    else
      i = x+1
      j = y
      while fixed.include?([j,i])
        i, j = next_cell(i, j)
      end
      return i,j
    end
  end

  # find previous cell that's not a fixed cell or beyond the boundaries
  # the highest x,y position this get's called at is y==4 && x==4
  def prev_cell(x, y)
    if x == 0 && y == 0
      puts "eek!"
      print_l
      exit
    elsif x == 0
      i = 8
      j = y-1
      while fixed.include?([j, i])
        i,j = prev_cell(i, j)
      end
      return i, j
    else
      i = x-1
      j = y
      while fixed.include?([j, i])
        i,j = prev_cell(i, j)
      end
      return i, j
    end
  end

  def solve
    counter = 0
    x = 0
    y = 0
    n = 1
    while n < 10
      if check(x, y, n) # if n can be inserted at x,y
        layout[y][x] = n # insert n at x,y
        x, y = next_cell(x, y) # based on x,y find which cell to go to next
        n = 0 # reset to zero (which will be incremented at end of while loop), so when the next cell is checked it starts checking from 1 (n=1)
      else # if n couldn't be inserted at x,y ...
        if n == 9 # ... either we've gone through a cycle of n=1-9 (i.e. we've tried every number and none work), so we must go back to the previous non-fixed cell
          layout[y][x] = 0 # rollback the current cell to 0
          x, y = prev_cell(x, y) # find the previous cell to go to
          if layout[y][x] == 9 # if that previous cell is 9, start cycling through numbers to indert from 0 (incremented to 1)
            n = 0
          else # else the number to try in that previous cell must be set to what's in that previous cell (will be incremented at end of while)
            n = layout[y][x]
          end
        #else do nothing - i.e. n will be incremented
        end
      end #end if check

      n = n + 1
      counter += 1
      if counter%500000 ==0
        print_l
      end

    end #end while n
  end #end def

  def solve
    counter = 0
    x = 0
    y = 0
    while true
        #try all other values for n at x,y
        temp = [1,2,3,4,5,6,7,8,9]
        temp.delete(layout[y][x])
        inserted = false
        while temp.length > 0
          # p temp
          n = temp.shift
          if check(x, y, n) # can n be inserted at x,y?
            layout[y][x] = n
            x, y = next_cell(x, y)
            inserted = true
            break
          end
        end
        if !inserted # no value inserted at x,y
          # puts "n!=0"
          layout[y][x] = 0 # rollback
          x, y = prev_cell(x, y)
        end

      counter += 1
      if counter%25000 ==0
        print_l
      end
    end #end while n
  end #end def



  def print_l
    count_row = 0
    count_col = 0
    puts "-"*25
    layout.each do |row|
      row.each do |ele|
        print ele, " "
        count_col += 1
        if count_col == 3
          print "| "
          count_col = 0
        end
      end
      count_row += 1
      if count_row == 3
        puts "\n" + "-"*25
        count_row = 0
      else
        puts
      end
    end
    puts "-"*60
  end

end
