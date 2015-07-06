module Util

  ENCODER = Hash.new do |h,k|
    h[k] = Hash[ k.chars.map.enum_for(:each_with_index).to_a.map(&:reverse) ]
  end
  DECODER = Hash.new do |h,k|
    h[k] = Hash[ k.chars.map.enum_for(:each_with_index).to_a ]
  end

  # 0 through 9 plus A through Z, without B8S5O0I1 or Q.
  # "234679ACDEFGHJKLMNPRTUVWXYZ"
  BASE27 = (('0'..'9').to_a + ('A'..'Z').to_a).delete_if{|char| char =~ /[B8S5O0I1Q]/}.join

  class Base

    def self.encode(value)
      ring = Util::ENCODER[Util::BASE27]
      base = Util::BASE27.length
      result = []
      until value == 0
        result << ring[ value % base ]
        value /= base
      end
      result.reverse.join
    end

    def self.decode(string)
      string = string.to_s
      return string if string.split('').include?('1') || string.split('').include?('0') # as 0 and 1 are included into exceptional chars
      ring = Util::DECODER[Util::BASE27]
      base = Util::BASE27.length
      string.reverse.chars.enum_for(:each_with_index).inject(0) do |sum,(char,i)|
        sum + ring[char] * base**i
      end
    end

  end

end
