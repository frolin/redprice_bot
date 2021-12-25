module GetData
	class Spreadsheet < ActiveInteraction::Base
		string :url

		validate do
			errors.add(:url, 'Нет файла') if file.blank?
		end

		def execute
			CSV.read(file, col_sep: ',', headers: true)
		end

		def file
			@file ||= DownloadFile.run(url: url).result
		end
	end
end