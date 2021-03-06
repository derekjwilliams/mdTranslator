# unpack source
# Reader - ADIwg JSON V1 to internal data structure

# History:
# 	Stan Smith 2013-11-26 original script
#   Stan Smith 2014-07-03 resolve require statements using Mdtranslator.reader_module
#   Stan Smith 2014-12-15 refactored to handle namespacing readers and writers
#   Stan Smith 2015-06-22 replace global ($response) with passed in object (responseObj)
#   Stan Smith 2015-07-14 refactored to remove global namespace constants

require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_citation')
require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_processStep')

module ADIWG
    module Mdtranslator
        module Readers
            module MdJson

                module Source

                    def self.unpack(hSource, responseObj)

                        # return nil object if input is empty
                        intDataSource = nil
                        return if hSource.empty?

                        # instance classes needed in script
                        intMetadataClass = InternalMetadata.new
                        intDataSource = intMetadataClass.newDataSource

                        # source - description
                        if hSource.has_key?('description')
                            s = hSource['description']
                            if s != ''
                                intDataSource[:sourceDescription] = s
                            end
                        end

                        # source - citation
                        if hSource.has_key?('citation')
                            hCitation = hSource['citation']
                            unless hCitation.empty?
                                intDataSource[:sourceCitation] = Citation.unpack(hCitation, responseObj)
                            end
                        end

                        # source - data sources
                        if hSource.has_key?('processStep')
                            aSourceSteps = hSource['processStep']
                            unless aSourceSteps.empty?
                                aSourceSteps.each do |hStep|
                                    intDataSource[:sourceSteps] << ProcessStep.unpack(hStep, responseObj)
                                end
                            end
                        end

                        return intDataSource
                    end

                end

            end
        end
    end
end
