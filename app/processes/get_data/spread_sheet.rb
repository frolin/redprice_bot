module GetData
	class SpreadSheet

		def initialize(url:)
			@url = url
		end

		def process
			path = DownloadFile.download(url: @url)
			CSV.read(path, col_sep: ',', headers: true)
		end
	end
end