require 'json'

# Get path to products.json, read the file into a string,
# and transform the string into a usable hash
#def setup_files
    path = File.join(File.dirname(__FILE__), '../data/products.json')
    file = File.read(path)
    $products_hash = JSON.parse(file)
    $report_file = File.new("report.txt", "w+")
		$products = $products_hash["items"]
		$padding_string = "-" * 15
		# Print today's date
		$brands = $products.map{|product| product["brand"]}.uniq
#end

def create_report
end

def start
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end
# Print "Sales Report" in ascii art
puts " #####                                 ######                                    "
puts "#     #   ##   #      ######  ####     #     # ###### #####   ####  #####  #####"
puts "#        #  #  #      #      #         #     # #      #    # #    # #    #   #  "
puts " #####  #    # #      #####   ####     ######  #####  #    # #    # #    #   #  "
puts "		 # ###### #      #           #    #   #   #      #####  #    # #####    #  "
puts "#     # #    # #      #      #    #    #    #  #      #      #    # #   #    #  "
puts " #####  #    # ###### ######  ####     #     # ###### #       ####  #    #   #  "
puts "********************************************************************************"

# Print today's date

# Print "Products" in ascii art

puts "                     _            _       "
puts "                    | |          | |      "
puts " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
puts "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
puts "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
puts "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
puts "| |                                       "
puts "|_|                                       "

# For each product in the data set:
$products.each do |product|
	puts $padding_string
	# Print the name of the toy
	puts "Name: " + product["title"]
	# Print the retail price of the toy
	puts "Retail Price: $" + product["full-price"]
	# Calculate and print the total number of purchases
	sales_count = product["purchases"].length
	puts "Sales: " + sales_count.to_s
  # Calcalate and print the total amount of sales
	sales_revenue = product["purchases"].inject(0) { |sales_total, sale| sales_total + sale["price"] }
	puts "Sales Revenue: " + "$%0.2f" % sales_revenue.round(2).to_s
  # Calculate and print the average price the toy sold for
	average_sale_price = sales_revenue/sales_count
	puts "Average Sale Price: " + "$%0.2f" % average_sale_price.round(2).to_s
  # Calculate and print the average discount based off the average sales price
	average_discount = product["full-price"].to_f - average_sale_price
	puts "Average Discount: " + "$%0.2f" % average_discount.round(2).to_s
end

# Print "Brands" in ascii art
puts " _                         _     "
puts "| |                       | |    "
puts "| |__  _ __ __ _ _ __   __| |___ "
puts "| '_ \\| '__/ _` | '_ \\ / _` / __|"
puts "| |_) | | | (_| | | | | (_| \\__ \\"
puts "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
puts

# For each brand in the data set:
$brands.each do |brand|
	brand_products = $products.find_all{|product| product["brand"] == brand}
	puts $padding_string
	# Print the name of the brand
	puts brand
	# Count and print the number of the brand's toys we stock
	brand_toy_count = brand_products.length
	puts "Unique Toys: " + brand_toy_count.to_s
	# Calculate and print the average price of the brand's toys
	sum_of_prices = brand_products.inject(0) {|sum_of_prices, product| sum_of_prices + product["full-price"].to_f}
	puts "Average Price: " + "$%0.2f" % (sum_of_prices/brand_toy_count.round(2)).to_s
	# Calculate and print the total sales volume of all the brand's toys combined
	total_brand_revenue = brand_products.inject(0) do |brand_revenue, product|
		brand_revenue + product["purchases"].inject(0) {|product_revenue, purchase| product_revenue + purchase["price"]}
	end
	puts "Total Brand Sales: " + "$%0.2f" % total_brand_revenue.round(2).to_s
end

#start
