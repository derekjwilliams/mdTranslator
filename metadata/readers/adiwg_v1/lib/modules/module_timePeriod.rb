# unpack time period
# Reader - ADIwg JSON V1 to internal data structure

# History:
# 	Stan Smith 2013-12-11 original script

require Rails.root + 'metadata/internal/internal_metadata_obj'
require Rails.root + 'metadata/readers/adiwg_v1/lib/modules/module_dateTime'

module AdiwgV1TimePeriod

	def self.unpack(hTimePeriod)

		# instance classes needed in script
		intMetadataClass = InternalMetadata.new

		# time period
		intTimePer = intMetadataClass.newTimePeriod

		if hTimePeriod.has_key?('id')
			s = hTimePeriod['id']
			if s != ''
				intTimePer[:timeID] = s
			end
		end

		if hTimePeriod.has_key?('description')
			s = hTimePeriod['description']
			if s != ''
				intTimePer[:description] = s
			end
		end

		if hTimePeriod.has_key?('beginPosition')
			s = hTimePeriod['beginPosition']
			if s != ''
				intTimePer[:beginTime] = AdiwgV1DateTime.unpack(s)

			end
		end

		if hTimePeriod.has_key?('endPosition')
			s = hTimePeriod['endPosition']
			if s != ''
				intTimePer[:endTime] = AdiwgV1DateTime.unpack(s)

			end
		end

		return intTimePer
	end

end