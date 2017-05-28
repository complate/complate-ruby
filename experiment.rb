# What is this shit with unusedArgs? See here:
# https://groups.google.com/forum/#!topic/javascript-and-friends/ezJ2RX3pwBU
require_relative 'library'

jsx = JSX.new("dist/bundle.js")

puts "-- INDEX --"
jsx.render("index")
puts

puts "-- ARTICLE --"
jsx.render('article', 'an author', 'a title', 'some content')
puts

puts "-- PRODUCTS --"
class Product
  attr_reader :id
  attr_reader :name

  def initialize(id, name)
    @id = id
    @name = name
  end

  def getPrice(*unusedArgs)
    sleep 1
    rand 100
  end
end

jsx.render("products", [
  Product.new(123, "toothpaste"),
  Product.new(456, "pencil"),
  Product.new(789, "soup"),
])
