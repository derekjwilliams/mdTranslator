# ISO <<Class>> CI_Telephone
# writer output in XML

# History:
# 	Stan Smith 2013-08-12 original script.
#   Stan Smith 2014-05-14 reorganized for JSON schema 0.4.0
#   Stan Smith 2014-12-12 refactored to handle namespacing readers and writers
#   Stan Smith 2015-06-22 replace global ($response) with passed in object (responseObj)
#   Stan Smith 2015-07-14 refactored to make iso19110 independent of iso19115_2 classes
#   Stan Smith 2015-07-14 refactored to eliminate namespace globals $WriterNS and $IsoNS

module ADIWG
    module Mdtranslator
        module Writers
            module Iso19115_2

                class CI_Telephone

                    def initialize(xml, responseObj)
                        @xml = xml
                        @responseObj = responseObj
                    end

                    def writeXML(aPhones)

                        # ISO requires phones to be in proper order (voice, fax)
                        # Need to count phones of each type to be able to include empty tag
                        voiceCount = 0
                        faxCount = 0
                        aPhones.each do |hPhone|
                            if hPhone[:phoneServiceType].nil?
                                hPhone[:phoneServiceType] = 'voice'
                            end
                            if hPhone[:phoneServiceType] == 'voice'
                                voiceCount += 1
                            end
                            if hPhone[:phoneServiceType] == 'fax'
                                faxCount += 1
                            end
                        end

                        @xml.tag!('gmd:CI_Telephone') do

                            # phone - voice phones
                            if voiceCount > 0
                                aPhones.each do |hPhone|
                                    if hPhone[:phoneServiceType] == 'voice'
                                        pName = hPhone[:phoneName]
                                        pNumber = hPhone[:phoneNumber]
                                        if pName.nil?
                                            s = pNumber
                                        else
                                            s = pName + ': ' + pNumber
                                        end
                                        @xml.tag!('gmd:voice') do
                                            @xml.tag!('gco:CharacterString', s)
                                        end
                                    end
                                end
                            elsif @responseObj[:writerShowTags]
                                @xml.tag!('gmd:voice')
                            end

                            # phone - fax phones
                            if faxCount > 0
                                aPhones.each do |hPhone|
                                    if hPhone[:phoneServiceType] == 'fax'
                                        pName = hPhone[:phoneName]
                                        pNumber = hPhone[:phoneNumber]
                                        if pName.nil?
                                            s = pNumber
                                        else
                                            s = pName + ': ' + pNumber
                                        end
                                        @xml.tag!('gmd:facsimile') do
                                            @xml.tag!('gco:CharacterString', s)
                                        end
                                    end
                                end
                            elsif @responseObj[:writerShowTags]
                                @xml.tag!('gmd:facsimile')
                            end
                        end

                    end

                end

            end
        end
    end
end
