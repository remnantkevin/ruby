# module which contains the sudoku solver method
#? would you use self in the method? or take in an arg?


  # def solve(x, y, n)
  #   @count = @count + 1
  #   if count == 10
  #     exit
  #   end
  #   p count
  #
  #   n = n % 9
  #   if n == 0
  #     n = 9
  #   end
  #
  #   puts "#{x},#{y},#{n}"
  #
  #   if x == -1 && y == 0
  #     false
  #   elsif x == 9 && y == 8
  #     true
  #   else
  #     if check(x, y, n)
  #       layout[y][x] = n
  #       print_l
  #       puts "-"*40
  #       if x == 8
  #         solve(0, y+1, 1)
  #       else
  #         solve(x+1, y, 1)
  #       end
  #     elsif n == 9
  #       if x == 0
  #         solve(8, y-1, layout[y-1][8]+1)
  #       else
  #         solve(x-1, y, layout[y][x-1]+1)
  #       end
  #     else
  #       solve(x, y, n+1)
  #     end
  #   end
  # end

def solve
  x = 0
  y = 0
  n = 0
  while y < 9
    x = 0
    while x < 9
      n = 1
      while n < 10
        if layout[y][x].class == String
          x, y = next_cell(x, y)
          n = 0
        else
          if check(x, y, n)
            layout[y][x] = n
            x, y = next_cell(x, y)
            n = 0
          else
            if n == 9
              layout[y][x] = 0
              x, y = prev_cell(x, y)
              if layout[y][x] == 9
                n = 0
              else
                n = layout[y][x]+1
              end
            #else do nothing - i.e. increment n
            end
          end
        end #end String
        n = n + 1
      end #end while n
      x = x + 1
    end #end while x
    y = y + 1
  end #end while y
end #end def


def solve
  # count = 0
  # 9.times do |y|
  #   9.times do |x|
  #     if count == 0 && x == 5 && y == 2
  #       y = 0
  #     end
  #     puts "x:#{x},y:#{y}"
  #   end
  # end
  x = 0
  y = 0
  n = 0
  count = 0
  while y < 9

    x = 0
    while x < 9
      n = 1
      while n < 10
        # puts "#{layout[y][x].class} || #{layout[y][x].class == String}"
        #puts y
# puts "*"*20
# print_l
# puts "*"*20

        if layout[y][x].class == String #if string > move on
        #  p "skip before: #{layout[y][x]} |  x: #{x},  y: #{y}, n: #{n}"
          x, y = next_cell(x, y)
          n = 0
        #  p "skip after: #{layout[y][x]} |  x: #{x},  y: #{y}, n: #{n}"
        else # not string
          if check(x, y, n) # can n be put at x, y? if yes: put it there and go to next cell
            layout[y][x] = n
            x, y = next_cell(x, y)
            n = 0
          else # if n can't be put at x,y ...
            if n == 9 # ... and n is 9 > we've run out of options and must go back and retry
            #  puts "n is: #{n} | x: #{x}, y: #{y}"
              layout[y][x] = 0
              x, y = prev_cell(x, y) # go back to retry
              if layout[y][x] == 9 # if the prev cell is 9, wrap around and start at n=1 again
              #  puts "layout[y][x]: layout[#{y}][#{x}]: #{layout[y][x]}"
                n = 0
              else # otherwise, increase the value to try (n) by 1 and start again
                n = layout[y][x]+1
                #puts "layout[y][x]: layout[#{y}][#{x}]: #{layout[y][x]}"
              end
            end
          end
        end

        n = n + 1
      end
      x = x + 1
    end
    y = y + 1
  end





end
