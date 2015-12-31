require 'json'

# Get path to products.json, read the file into a string,
# and transform the string into a usable hash
def setup_files
  path = File.join(File.dirname(__FILE__), '../data/products.json')
  file = File.read(path)
  $products_hash = JSON.parse(file)
  $report_file = File.new("report.txt", "w+")
end

def config
	$products = $products_hash["items"]
	$brands = $products.map{|product| product["brand"]}.uniq
	$rule_character = "*"
end

def create_report
	path = File.join(File.dirname(__FILE__), 'report.txt')
	file = File.new(path,"w")
	report = []
	report.push print_sales_report_header
	report.push print_products_report_header
	report.push print_products
	report.push print_brands_report_header
	report.push print_brands
	file.write(report.join("\n"))
	file.close
end

def start
	setup_files # load, read, parse, and create the files
	config # setup configuration
  create_report # create the report!
end

# Print repeated characters to break up text
def print_rule(string_to_repeat, times_to_repeat)
	return string_to_repeat * times_to_repeat
end

# Print "Sales Report" in ascii art
def print_sales_report_header
	sales_report_header = []
	sales_report_header.push " #####                                 ######                                    "
	sales_report_header.push "#     #   ##   #      ######  ####     #     # ###### #####   ####  #####  #####"
	sales_report_header.push "#        #  #  #      #      #         #     # #      #    # #    # #    #   #"
	sales_report_header.push " #####  #    # #      #####   ####     ######  #####  #    # #    # #    #   #"
	sales_report_header.push "      # ###### #      #           #    #   #   #      #####  #    # #####    #"
	sales_report_header.push "#     # #    # #      #      #    #    #    #  #      #      #    # #   #    #"
	sales_report_header.push " #####  #    # ###### ######  ####     #     # ###### #       ####  #    #   #"
	sales_report_header.push "********************************************************************************"
	return sales_report_header.join("\n")
end

###############################
# ASCII ART HEADERS
###############################

# Print "Products" in ascii art
def print_products_report_header
	products_report_header = []
	products_report_header.push "                     _            _       "
	products_report_header.push "                    | |          | |      "
	products_report_header.push " _ __  _ __ ___   __| |_   _  ___| |_ ___ "
	products_report_header.push "| '_ \\| '__/ _ \\ / _` | | | |/ __| __/ __|"
	products_report_header.push "| |_) | | | (_) | (_| | |_| | (__| |_\\__ \\"
	products_report_header.push "| .__/|_|  \\___/ \\__,_|\\__,_|\\___|\\__|___/"
	products_report_header.push "| |                                       "
	products_report_header.push "|_|                                       "
	return products_report_header.join("\n") + "\n"
end

# Print "Brands" in ascii art
def print_brands_report_header
	brand_header = []
	brand_header.push " _                         _     "
	brand_header.push "| |                       | |    "
	brand_header.push "| |__  _ __ __ _ _ __   __| |___ "
	brand_header.push "| '_ \\| '__/ _` | '_ \\ / _` / __|"
	brand_header.push "| |_) | | | (_| | | | | (_| \\__ \\"
	brand_header.push "|_.__/|_|  \\__,_|_| |_|\\__,_|___/"
	brand_header.push ""
	return brand_header.join("\n")
end

###############################
# Product Functions
###############################

def print_product_title(product)
	return "--" + product["title"] + "--"
end

def print_product_retail_price(product)
	return "Retail Price: " + "$%0.2f" % product["full-price"]
end

def product_sales_count(product)
	return product["purchases"].length
end

def print_product_total_purchases(product)
	return "Total Purchases: " + product_sales_count(product).to_s
end

def product_sales_revenue(product)
	return product["purchases"].inject(0) { |sales_total, sale| sales_total + sale["price"] }
end

def print_product_total_sales_amount(product)
	return "Total Sales Volume: " + "$%0.2f" % product_sales_revenue(product).to_s
end

def product_average_price(product)
	return product_sales_revenue(product)/product_sales_count(product)
end

def print_product_average_price(product)
	return "Average Price: " + "$%0.2f" % product_average_price(product).to_s
end

def product_average_discount(product)
	return (product["full-price"].to_f - product_average_price(product))/product["full-price"].to_f*100
end

def print_average_discount(product)
	return "Average Discount: " + "%0.2f%" % product_average_discount(product).to_s
end

def print_product(product)
	print_result = []
	print_result.push print_rule($rule_character, product["title"].length)
	# Print the name of the toy
	print_result.push print_product_title(product)
	# Print the retail price of the toy
	print_result.push print_product_retail_price(product)
	# Calculate and print the total number of purchases
	print_result.push print_product_total_purchases(product)
	# Calcalate and print the total amount of sales
	print_result.push print_product_total_sales_amount(product)
	# Calculate and print the average price the toy sold for
	print_result.push print_product_average_price(product)
	# Calculate and print the average discount based off the average sales price
	print_result.push print_average_discount(product)
	print_result.push print_rule($rule_character, product["title"].length)
	return print_result.join("\n")
end

def print_products
	products = []
# For each product in the data set:
	$products.each do |product|
		products.push print_product(product)
	end
	return products.join("\n" * 2)
end

###############################
# Brand Functions
###############################

def brand_products(brand)
	return $products.find_all{|product| product["brand"] == brand}
end

def brand_toy_count(products)
	return products.length
end

def print_brand_toy_count(products)
	return "Number of Products: " + brand_toy_count(products).to_s
end

def brand_stock(products)
	return products.inject(0) {|sum_of_prices, product| sum_of_prices + product["stock"].to_f}
end

def print_brand_stock(products)
	return "Number of Products In Stock: " + "%0.0f" % brand_stock(products)
end

def brand_average_full_price(products)
	return products.inject(0) {|sum_of_prices, product| sum_of_prices + product["full-price"].to_f}/brand_toy_count(products)
end

def brand_sales(products)
  return products.inject(0) do |brand_sales, product|
    brand_sales + product["purchases"].length
  end
end

def brand_revenue(products)
	return products.inject(0) do |brand_revenue, product|
		brand_revenue + product["purchases"].inject(0) {|product_revenue, purchase| product_revenue + purchase["price"]}
	end
end

def brand_average_price(products)
	return brand_revenue(products)/brand_sales(products)
end

def print_brand_average_price(products)
	return "Average Product Price: " + "$%0.2f" % brand_average_price(products).to_s
end

def print_brand_revenue(products)
	return "Total Sales: " + "$%0.2f" % brand_revenue(products).to_s
end

def print_brand(brand)
	brand_result = []
	products = brand_products(brand)
	brand_result.push brand
	brand_result.push print_rule($rule_character, 21)
	# Print the name of the brand
	# Count and print the number of the brand's toys we stock
	brand_result.push print_brand_toy_count(products)
	# Count and print the number of the brand's toys we have in stock
	brand_result.push print_brand_stock(products)
	# Calculate and print the average price of the brand's toys
	brand_result.push print_brand_average_price(products)
	# Calculate and print the total sales volume of all the brand's toys combined
	brand_result.push print_brand_revenue(products)
	brand_result.push print_rule($rule_character, 21)
	return brand_result.join("\n")
end

def print_brands
	brands = []
	# For each brand in the data set:
	$brands.each do |brand|
		brands.push print_brand(brand)
	end
	return brands.join("\n" * 2)
end

start
