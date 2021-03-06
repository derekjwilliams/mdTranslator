# ISO <<Class>> EX_Extent
# writer output in XML

# History:
# 	Stan Smith 2013-11-01 original script
# 	Stan Smith 2013-11-15 add temporal elements
# 	Stan Smith 2013-11-15 add vertical elements
#   Stan Smith 2014-05-29 changes for json schema version 0.5.0
#   Stan Smith 2014-05-29 ... added new class for geographicElement
#   Stan Smith 2014-07-08 modify require statements to function in RubyGem structure
#   Stan Smith 2014-12-12 refactored to handle namespacing readers and writers
#   Stan Smith 2015-06-22 replace global ($response) with passed in object (responseObj)
#   Stan Smith 2015-07-14 refactored to make iso19110 independent of iso19115_2 classes
#   Stan Smith 2015-07-14 refactored to eliminate namespace globals $WriterNS and $IsoNS

require_relative 'class_geographicElement'
require_relative 'class_geographicDescription'
require_relative 'class_temporalExtent'
require_relative 'class_verticalExtent'

module ADIWG
    module Mdtranslator
        module Writers
            module Iso19115_2

                class EX_Extent

                    def initialize(xml, responseObj)
                        @xml = xml
                        @responseObj = responseObj
                    end

                    def writeXML(hExtent)

                        # classes used
                        tempExtClass =  EX_TemporalExtent.new(@xml, @responseObj)
                        vertExtClass =  EX_VerticalExtent.new(@xml, @responseObj)
                        geoEleClass =  GeographicElement.new(@xml, @responseObj)
                        geoEleIdClass =  EX_GeographicDescription.new(@xml, @responseObj)

                        @xml.tag!('gmd:EX_Extent') do

                            # extent - description
                            s = hExtent[:extDesc]
                            if !s.nil?
                                @xml.tag!('gmd:description') do
                                    @xml.tag!('gco:CharacterString', s)
                                end
                            elsif @responseObj[:writerShowTags]
                                @xml.tag!('gmd:description')
                            end

                            # extent - geographic element - for geometry
                            aGeoElements = hExtent[:extGeoElements]
                            if !aGeoElements.empty?
                                aGeoElements.each do |hGeoElement|
                                    @xml.tag!('gmd:geographicElement') do
                                        geoEleClass.writeXML(hGeoElement)
                                    end
                                end
                            elsif @responseObj[:writerShowTags]
                                @xml.tag!('gmd:geographicElement')
                            end

                            # extent - geographic element - for identifier
                            aGeoElements = hExtent[:extIdElements]
                            if !aGeoElements.empty?
                                aGeoElements.each do |hGeoElement|
                                    @xml.tag!('gmd:geographicElement') do
                                        geoEleIdClass.writeXML(hGeoElement)
                                    end
                                end
                            end

                            # extent - temporal element
                            aTempElements = hExtent[:extTempElements]
                            if !aTempElements.empty?
                                aTempElements.each do |hTempElement|
                                    @xml.tag!('gmd:temporalElement') do
                                        tempExtClass.writeXML(hTempElement)
                                    end
                                end
                            elsif @responseObj[:writerShowTags]
                                @xml.tag!('gmd:temporalElement')
                            end

                            # extent - vertical element
                            aVertElements = hExtent[:extVertElements]
                            if !aVertElements.empty?
                                aVertElements.each do |hVertElement|
                                    @xml.tag!('gmd:verticalElement') do
                                        vertExtClass.writeXML(hVertElement)
                                    end
                                end
                            elsif @responseObj[:writerShowTags]
                                @xml.tag!('gmd:verticalElement')
                            end
                        end

                    end

                end

            end
        end
    end
end
