class DownloadFile
	PATH = 'public/download/csv'

	def initialize(url:, format: 'csv')
		@url = url
		@tempfile = Down.download(@url)
	end

	def self.download(url:, format: 'csv')
		new(url: url).download_file
	end

	def file
		file_name =  File.basename(@tempfile.path)

		@file ||= "#{PATH}/#{file_name}"
	end

	def download_file
		if new_file?
			FileUtils.mv(@tempfile.path, file)
			Rails.logger.info "Download file to #{file}"

			file
		else
			Rails.logger.info 'File already exists with same size'

			file
		end
	end

	def new_file?
		!File.exists?(file) # && !FileUtils.compare_file(@tempfile, file)
	end
end
