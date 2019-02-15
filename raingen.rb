require 'digest'
require 'slop'

class Raingen_File
	def initialize(inpfile,outfile="generatedrt.rt")
		@opfile = outfile.to_s
		@inpfile = inpfile.to_s
		if File.exists?(@inpfile) and File.file?(@inpfile)
			puts "Arguments: #{@inpfile} #{@outfile}"

		else
			puts "[-] #{@inpfile} #{@outfile} are not files. Error"
		end
		@delimiter = '\n'
		@hashdict = Hash.new(0)
		@filedict = Hash.new(0)

	end

	def gen_hashes()
		puts "[*] File #{@opfile} was given as input"
		file = File.new(@opfile,'r')
		filedata = File.sysread(file)
		file.close()
		filedataarr = filedata.split(/@delimiter/)
		filedataarr.each do |dat|
			@hashdict['SHA256'] = Digest::SHA256.hexdigest(dat)
			@hashdict['SHA512'] = Digest::SHA512.hexdigest(dat)
			@hashdict['MD5'] = Digest::MD5.hexdigest(dat)
			@hashdict['RMD160'] = Digest::RMD160.hexdigest(dat)
			@filedict[dat.to_s] = @hashdict
			@hashdict = Hash.new(0)
		end
	end

	def save_to_file()
		puts "[*] Name of Output File: #{opfile}"
		hash_file = File.new(@opfile,'w')
		hash_file.syswrite(@hashdict)
		hash_file.close
		puts "[+] Hash File Genearation Sucessful"
		puts "[*] Location of Hash File: ./#{File.absolute_path(hash_file)}"
		
	end
end

class Raingen_String 
	def initialize(string)
		@string = string
		puts "Argument: #{@string} is of type #{@string.class}"
	end

	def gen_hashes()
		puts "SHA 512 => #{Digest::SHA512.hexdigest(@string)}"
		puts "SHA 256 => #{Digest::SHA256.hexdigest(@string)}"
		puts "MD5     => #{Digest::MD5.hexdigest(@string)}"
		puts "RMD160  => #{Digest::RMD160.hexdigest(@string)}"
		puts "[+] Hash Generation Sucessful"
	end
end



def main()
	options = Slop.parse do |opts|
		opts.string '-if', '--inputfile', 'Input file for rainbow table generation'
		opts.string '-of', '--outputfile', 'Output file for storing generated rainbow table'
		opts.string '-s', '--string', 'Do operations on just one string. Warning: Will not save to file'
	end


	if options[:if] or options[:inputfile]
		inputfile = File.new(options[:if],'r')
	end
	if options[:of] or options[:outputfile]
		outputfile = File.new(options[:of],'w')
	end
	if options[:s] or options[:string]
		raingenstr = Raingen_String.new(options[:s])
		raingenstr&.gen_hashes
	end
	if File.exists?(inputfile&.to_s) and File.exists?(outputfile&.to_s) 
		puts "[+] Both Input File and Output File exist"
		puts "[*] Starting Hash Table Generation"
		raingenfile = Raingen_File.new(inputfile.to_s,outputfile.to_s)
		raingenfile.gen_hashes()
		raingenfile.save_to_file()
	elsif File.exists?(inputfile) and !File.exists?(outfile)
		puts "[*] Input File: #{inputfile}"
		puts "[*] No Output File specified. Default name of output File: generatedrt.rt"
		raingenfile = Raingen_File.new(inputfile)
		raingenfile.gen_hashes()
		raingenfile.save_to_file()
	else
		puts "[-] No File or String Arguments Specified"
		puts "Exiting"
	end
end




main()

		


		
	
