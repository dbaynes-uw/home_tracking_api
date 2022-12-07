class String
  SPACE = ' '
  DASH = '-'
  APOS = "'"

  # Extension of the string class to properly handle camel names
  def nameize
    case self
      when / /
        # If the name has a space in it, we gotta run the parts through the nameizer.
        split(SPACE).each { |part| part.nameize! }.join(SPACE)
      when /-/
        # If the name has a space in it, we gotta run the parts through the nameizer.
        split(DASH).each { |part| part.nameize! }.join(DASH)
      when /^(mac|mc)(\w)(.*)$/i
        "#{$1.capitalize}#{$2.capitalize}#{$3}"
      when /^o\'/i
        split(APOS).each{ |piece| piece.capitalize! }.join(APOS)
      else
        capitalize # Basically if the name is a first name or it's not Irish then capitalize it.
    end
  end
  def nameize!
  replace nameize # BANG!
  end

  # COLORS:
  def black;          "\e[30m#{self}\e[0m" end
  def red;            "\e[31m#{self}\e[0m" end
  def green;          "\e[32m#{self}\e[0m" end
  def brown;          "\e[33m#{self}\e[0m" end
  def blue;           "\e[34m#{self}\e[0m" end
  def magenta;        "\e[35m#{self}\e[0m" end
  def cyan;           "\e[36m#{self}\e[0m" end
  def gray;           "\e[37m#{self}\e[0m" end

  def bg_black;       "\e[40m#{self}\e[0m" end
  def bg_red;         "\e[41m#{self}\e[0m" end
  def bg_green;       "\e[42m#{self}\e[0m" end
  def bg_brown;       "\e[43m#{self}\e[0m" end
  def bg_blue;        "\e[44m#{self}\e[0m" end
  def bg_magenta;     "\e[45m#{self}\e[0m" end
  def bg_cyan;        "\e[46m#{self}\e[0m" end
  def bg_gray;        "\e[47m#{self}\e[0m" end

  def bold;           "\e[1m#{self}\e[22m" end
  def italic;         "\e[3m#{self}\e[23m" end
  def underline;      "\e[4m#{self}\e[24m" end
  def blink;          "\e[5m#{self}\e[25m" end
  def reverse_color;  "\e[7m#{self}\e[27m" end

end
