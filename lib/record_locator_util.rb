module Util

  ENCODER = Hash.new do |h,k|
    h[k] = Hash[ k.chars.map.enum_for(:each_with_index).to_a.map(&:reverse) ]
  end
  DECODER = Hash.new do |h,k|
    h[k] = Hash[ k.chars.map.enum_for(:each_with_index).to_a ]
  end

  # 0 through 9 plus A through Z, without O0I1 or Q.
  # "23456789ABCDEFGHJKLMNPRSTUVWXYZ"
  BASE31 = (('0'..'9').to_a + ('A'..'Z').to_a).delete_if{|char| char =~ /[O0I1Q]/}.join

  class Base

    def self.encode(value)
      ring = Util::ENCODER[Util::BASE31]
      base = Util::BASE31.length
      result = []
      until value == 0
        result << ring[ value % base ]
        value /= base
      end
      result.reverse.join
    end

    def self.decode(string)
      string = string.to_s
      ring = Util::DECODER[Util::BASE31]
      base = Util::BASE31.length
      string.reverse.chars.with_index.inject(0) do |sum,(char,i)|
        sum + ring[char] * base**i
      end
    end

  end

end