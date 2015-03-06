require 'csv'

#method to process the phone numbers
def extract_phone_number(phone)
	#remove the + and the country code if its a '+254'
  if phone.gsub(/\D/, "").match(/^[0-9][0-9][0-9]?(\d{2})(\d{3})(\d{4})/)
		[$1, $2, $3].join() #join the three parts of the number to avoid whitespaces 
	else
		phone.match(/^[0-9]?(\d{2})(\d{3})(\d{4})/) # remove the 0 if if it's a '07'
		[$1, $2, $3].join() 
	end
end

#method to check for empty/blank entries in array
def is_blank? item
	item.nil? || item.gsub(/\s+/, "").empty?
end


def generate_Array
	array = Array.new
	#open the csv file and  skip the headers when parsing through it
	CSV.foreach('c.csv', {headers: true}) do |row| 
		name = "#{row[0]} #{row[2]}".strip #concatenate first and last name 
		#check for the phone number in all the different phone number columns
		phone =row[20] || row[17] || row[18] || row[19] || row[38] || row[39] || row[40] || row[58] || row[70] || row[72] || row[73]
			
		if !phone.nil?
			#if a number starts with 07 or +254 process it
		  if ( phone.start_with?("+254") || phone.start_with?("07") )	
			  phone.gsub!(/\s+/, "") #remove whitespaces
				phone_n = extract_phone_number(phone) 
			end	
		end
		
		array << [name,phone_n] #add the name and phone number to array
	end
	array.reject! { |elem| is_blank?(elem[1]) } #remove element from array if it's blank
  array.unshift(["Name","Phone Number"]) #add headers
  write_to_CSV(array)
end



def write_to_CSV(array)
	#loop that writes the array to the new .csv file 
	CSV.open('c2.csv', 'w') do |csv_object| #open the new csv file and grant write access
		for e in array do 
			csv_object << e #write row e to csv file
		end
	end
end
		
generate_Array()		



