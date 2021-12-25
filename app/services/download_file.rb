class DownloadFile < ActiveInteraction::Base
	string :url

	validate do
		errors.add(:base, 'нет файла') if file.blank?
	end

	def execute
		file
	end

	def file
		@file ||= Down.download(url)
	rescue => e
		Rails.logger.error(e.message)
	end
end
