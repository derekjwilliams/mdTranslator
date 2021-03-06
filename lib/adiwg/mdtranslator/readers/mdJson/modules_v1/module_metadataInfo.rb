# unpack metadata information block
# Reader - ADIwg JSON V1 to internal data structure

# History:
# 	Stan Smith 2014-04-24 original script - moved from module_metadata
#   Stan Smith 2014-07-03 resolve require statements using Mdtranslator.reader_module
#   Stan Smith 2014-09-19 changed metadata identifier type resource identifier json 0.8.0
#   Stan Smith 2014-09-19 changed parent metadata identifier type citation json 0.8.0
#   Stan Smith 2014-11-06 removed metadataScope, moved to resourceType under resourceInfo json 0.9.0
#   Stan Smith 2014-12-15 refactored to handle namespacing readers and writers
#   Stan Smith 2015-06-12 added support for metadataCharacterSet
#   Stan Smith 2015-06-22 replace global ($response) with passed in object (responseObj)
#   Stan Smith 2015-07-14 refactored to remove global namespace constants
#   Stan Smith 2015-07-28 added support for locale

require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_responsibleParty')
require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_dateTime')
require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_resourceMaintenance')
require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_metadataExtension')
require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_resourceIdentifier')
require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_citation')
require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_locale')

module ADIWG
    module Mdtranslator
        module Readers
            module MdJson

                module MetadataInfo

                    def self.unpack(hMetadata, responseObj)

                        # return nil object if input is empty
                        intMetadataInfo = nil
                        return if hMetadata.empty?

                        # instance classes needed in script
                        intMetadataClass = InternalMetadata.new
                        intMetadataInfo = intMetadataClass.newMetadataInfo
                        hMetadataInfo = hMetadata['metadataInfo']

                        # metadata - metadata identifier
                        if hMetadataInfo.has_key?('metadataIdentifier')
                            hMetadataId = hMetadataInfo['metadataIdentifier']
                            unless hMetadataId.empty?
                                intMetadataInfo[:metadataId] = ResourceIdentifier.unpack(hMetadataId, responseObj)
                            end
                        end

                        # metadata - parent metadata identifier
                        if hMetadataInfo.has_key?('parentMetadata')
                            hParent = hMetadataInfo['parentMetadata']
                            unless hParent.empty?
                                intMetadataInfo[:parentMetadata] = Citation.unpack(hParent, responseObj)
                            end
                        end

                        # metadata - metadata contacts, custodians
                        if hMetadataInfo.has_key?('metadataContact')
                            aCust = hMetadataInfo['metadataContact']
                            unless aCust.empty?
                                aCust.each do |rParty|
                                    intMetadataInfo[:metadataCustodians] << ResponsibleParty.unpack(rParty, responseObj)
                                end
                            end
                        end

                        # metadata - creation date
                        if hMetadataInfo.has_key?('metadataCreationDate')
                            s = hMetadataInfo['metadataCreationDate']
                            if s != ''
                                hDateTime = DateTime.unpack(s, responseObj)
                                hDateTime[:dateType] = 'publication'
                                intMetadataInfo[:metadataCreateDate] = hDateTime
                            end
                        end

                        # metadata - date of last metadata update
                        if hMetadataInfo.has_key?('metadataLastUpdate')
                            s = hMetadataInfo['metadataLastUpdate']
                            if s != ''
                                hDateTime = DateTime.unpack(s, responseObj)
                                hDateTime[:dateType] = 'revision'
                                intMetadataInfo[:metadataUpdateDate] = hDateTime
                            end
                        end

                        # metadata - characterSet - default 'utf8'
                        if hMetadataInfo.has_key?('metadataCharacterSet')
                            s = hMetadataInfo['metadataCharacterSet']
                            if s != ''
                                intMetadataInfo[:metadataCharacterSet] = s
                            else
                                intMetadataInfo[:metadataCharacterSet] = 'utf8'
                            end
                        end

                        # metadata - locale
                        if hMetadataInfo.has_key?('metadataLocale')
                            aLocale = hMetadataInfo['metadataLocale']
                            unless aLocale.empty?
                                aLocale.each do |hLocale|
                                    intMetadataInfo[:metadataLocales] << Locale.unpack(hLocale, responseObj)
                                end
                            end
                        end

                        # metadata - metadata URI
                        if hMetadataInfo.has_key?('metadataUri')
                            s = hMetadataInfo['metadataUri']
                            if s != ''
                                intMetadataInfo[:metadataURI] = s
                            end
                        end

                        # metadata - status
                        if hMetadataInfo.has_key?('metadataStatus')
                            s = hMetadataInfo['metadataStatus']
                            if s != ''
                                intMetadataInfo[:metadataStatus] = s
                            end
                        end

                        # metadata - metadata maintenance info
                        if hMetadataInfo.has_key?('metadataMaintenance')
                            hMetaMaint = hMetadataInfo['metadataMaintenance']
                            unless hMetaMaint.empty?
                                intMetadataInfo[:maintInfo] = ResourceMaintenance.unpack(hMetaMaint, responseObj)
                            end
                        end

                        # metadata - extension info - if biological extension
                        if hMetadata.has_key?('resourceInfo')
                            resourceInfo = hMetadata['resourceInfo']
                            if resourceInfo.has_key?('taxonomy')
                                hTaxonomy = resourceInfo['taxonomy']
                                unless hTaxonomy.empty?
                                    intMetadataInfo[:extensions] << MetadataExtension.addExtensionISObio(responseObj)
                                end
                            end
                        end

                        return intMetadataInfo

                    end

                end

            end
        end
    end
end
