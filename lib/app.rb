require 'json'

# Get path to products.json, read the file into a string,
# and transform the string into a usable hash
def setup_files
    path = File.join(File.dirname(__FILE__), '../data/products.json')
    file = File.read(path)
    $products_hash = JSON.parse(file)
    $report_file = File.new("report.txt", "w+")
		$products = $products_hash["items"]
		# Print today's date
		$brands = $products.map{|product| product["brand"]}.uniq
		$rule_character = "*"
end

def create_report
	print_sales_report_header
	print_products_report_header
	print_products
	print_brands_report_header
	print_brands
	puts $result.join("\n")
end

def start
	$result = []
  setup_files # load, read, parse, and create the files
  create_report # create the report!
end

# Print repeated characters to break up text
def print_rule(string_to_repeat, times_to_repeat)
	return string_to_repeat * times_to_repeat
end

# Print "Sales Report" in ascii art
def print_sales_report_header
	$result.push " #####                                 ######                                    "
	$result.push "#     #   ##   #      ######  ####     #     # ###### #####   ####  #####  #####"
	$result.push "#        #  #  #      #      #         #     # #      #    # #    # #    #   #"
	$result.push " #####  #    # #      #####   ####     ######  #####  #    # #    # #    #   #"
	$result.push "      # ###### #      #           #    #   #   #      #####  #    # #####    #"
	$result.push "#     # #    # #      #      #    #    #    #  #      #      #    # #   #    #"
	$result.push " #####  #    # ###### ######  ####     #     # ###### #       ####  #    #   #"
	$result.push "********************************************************************************"
end
# Print today's date

# Print "Products" in ascii art
def print_products_report_header
	$result.push "                     _            _       "
	$result.push "                    | |          | |      "
	$result.push " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
	$result.push "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
	$result.push "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
	$result.push "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
	$result.push "| |                                       "
	$result.push "|_|                                       "
	$result.push ""
end

def print_products
# For each product in the data set:
	$products.each do |product|
		$result.push print_rule($rule_character, product["title"].length)
		# Print the name of the toy
		$result.push "--" + product["title"] + "--"
		# Print the retail price of the toy
		$result.push "Retail Price: " + "$%0.2f" % product["full-price"]
		# Calculate and print the total number of purchases
		sales_count = product["purchases"].length
		$result.push "Total Purchases: " + sales_count.to_s
	  # Calcalate and print the total amount of sales
		sales_revenue = product["purchases"].inject(0) { |sales_total, sale| sales_total + sale["price"] }
		$result.push "Total Sales Volume: " + "$%0.2f" % sales_revenue.round(2).to_s
	  # Calculate and print the average price the toy sold for
		average_sale_price = sales_revenue/sales_count
		$result.push "Average Price: " + "$%0.2f" % average_sale_price.round(2).to_s
	  # Calculate and print the average discount based off the average sales price
		average_discount = (product["full-price"].to_f - average_sale_price)/product["full-price"].to_f*100
		$result.push "Average Discount: " + "%0.2f%" % average_discount.round(2).to_s
		$result.push print_rule($rule_character, product["title"].length)
		$result.push ""
	end
end

def print_brands_report_header
	# Print "Brands" in ascii art
	$result.push " _                         _     "
	$result.push "| |                       | |    "
	$result.push "| |__  _ __ __ _ _ __   __| |___ "
	$result.push "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	$result.push "| |_) | | | (_| | | | | (_| \\__ \\"
	$result.push "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
	$result.push ""
end

def print_brands
	# For each brand in the data set:
	$brands.each do |brand|
		brand_products = $products.find_all{|product| product["brand"] == brand}
		$result.push print_rule($rule_character, 21)
		# Print the name of the brand
		$result.push brand
		# Count and print the number of the brand's toys we stock
		brand_toy_count = brand_products.length
		$result.push "Number of Products: " + brand_toy_count.to_s
		# Count and print the number of the brand's toys we have in stock
		sum_of_stock = brand_products.inject(0) {|sum_of_prices, product| sum_of_prices + product["stock"].to_f}
		$result.push "Number of Products In Stock: " + "%0.0f" % sum_of_stock
		# Calculate and print the average price of the brand's toys
		sum_of_prices = brand_products.inject(0) {|sum_of_prices, product| sum_of_prices + product["full-price"].to_f}
		$result.push "Average Product Price: " + "$%0.2f" % (sum_of_prices/brand_toy_count.round(2)).to_s
		# Calculate and print the total sales volume of all the brand's toys combined
		total_brand_revenue = brand_products.inject(0) do |brand_revenue, product|
			brand_revenue + product["purchases"].inject(0) {|product_revenue, purchase| product_revenue + purchase["price"]}
		end
		$result.push "Total Sales: " + "$%0.2f" % total_brand_revenue.round(2).to_s
		$result.push print_rule($rule_character, 21)
		$result.push ""
	end
end
start
