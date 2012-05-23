# reads scaffold.json file, which essentially contains the json fixture from manish
# then, converts that fixture to a scaffold string and outputs on terminal
# eases a lot of pain in writing long scaffolds


require 'json'

json = File.read('scaffold.json')
scaf = JSON.parse(json)
fields =  scaf['json'].keys
puts "rails g scaffold property " + fields.join(':text ').to_s+":text"

# following code will read everything from json fixture which contains _image in it, i.e image fields
# and will generate paperclip directives to be put inside properties.rb, the model
# this also eases pain

=begin
has_attached_file :photo,
						:styles => {  :thumb => "300x300>" },
                  :storage => :cloud_files, 
                  :cloudfiles_credentials => "/home/osman/paperclipdemo/config/rackspace_cloudfiles.yml"
=end

image_fields = [ ]

fields.each do |field|
	
	if field.scan("_image")[0].to_s.eql?("_image") == true
		image_fields << field
	end

end

local =  '/home/osman/bigscaffold/config/rackspace_cloudfiles.yml'
production =  '/home/osman/railsapps/bigscaffold/paperclipdemo/config/rackspace_cloudfiles.yml'

image_field_name = "placeholder"
fixture = "has_attached_file :"+image_field_name+",:styles => {  :thumb => '300x300>' },:storage =>:cloud_files,:cloudfiles_credentials => '/home/osman/paperclipdemo/config/rackspace_cloudfiles.yml'"

image_fields.each do |image_field|
	puts  "\nhas_attached_file :"+image_field+",:styles => {  :thumb => '300x300>' },:storage =>:cloud_files,:cloudfiles_credentials =>"+ "'" + local+ "'" +"\n"
end


# paperclip migration generator
image_fields.each do |i|
pmg = "rails g paperclip property " + i
puts pmg
end

controller_fixture = "placeholder"
# generator for view corresponding to rackspace generated files and lnks to them
image_fields.each do |i|
puts "@property."+i+" = StringIO.new(Base64.decode64(params[:property][:"+i+"]))"
end
