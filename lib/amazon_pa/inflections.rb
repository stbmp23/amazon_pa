module AmazonPa
  module Inflections
    # Converts strings to UpperCamelCase
    def camelize(term)
      string = term.to_s
      string = string.sub(/^[a-z\d]*/){ $&.capitalize }
      string.gsub(/(?:_|(\/))([a-z\d]*)/){ $2.capitalize }.gsub('/', '::')
    end

    # Makes an underscored
    def underscore(camel_case_word)
      word = camel_case_word.to_s.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr("-", "_")
      word.downcase!
      word
    end
  end
end
