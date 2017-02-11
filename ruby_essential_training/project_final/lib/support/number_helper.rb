# This module illustrates how additional functionality can be included (or "mixed-in") to a class and then reused. It borrows heaily from Rails' number_to_currency method

module NumberHelper

  def number_to_currency(number, options={})
    unit      = options[:unit]      || "$"
    precision = options[:precision] || 2
    delimeter = options[:delimeter] || ","
    separator = options[:separator] || "."

    separator = "" if precision == 0

    integer, decimal = number.to_s.split(".")

    i = integer.length
    until i <= 3
      i -= 3
      integer = integer.insert(i,delimeter)
    end

    if precision == 0
      precise_decimal = ""
    else
      #make sure decimal not nil
      decimal ||= "0" # decimal = decimal || "0"  #? why not empty string?

      #make sure decimal is not too big
      decimal = decimal[0,precision-1] #? couldn't this be nil if precision is 0? #? use this or [0...2]?

      #make sure decimal is not too short
      #want to left justify (pad out) decimal up to a length of precision, with "0"'s'
      precise_decimal = decimal.ljust(precision, "0")  #my version: decimal + "0"*(precision-decimal.length)
    end

    return unit + integer + separator + precise_decimal #?precise decimal scope?

  end

end
