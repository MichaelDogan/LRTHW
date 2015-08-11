#! /usr/bin/ruby

class Customer
	@@no_of_customers=0
	def initialize(id, name, addr)
		@@no_of_customers +=1
		@cust_id=id
		@cust_name=name
		@cust_addr=addr
	end
	def display_details()
		puts "Customer id#@cust_id"
		puts "Customer name #@cust_name"
		puts "Customer Address #@cust_addr"
	end
	def total_no_of_customers()
		puts "Total number of customers: #@@no_of_customers"
	end
end

# Create Objects
cust1=Customer.new("1", "Michael", "2235 Lake Rd. Ontario NY")
cust2=Customer.new("2", "Tom", "1840 Alder St. Pittsburgh PA")

#Call Methods
cust1.display_details()
cust2.display_details()
cust2.total_no_of_customers()
