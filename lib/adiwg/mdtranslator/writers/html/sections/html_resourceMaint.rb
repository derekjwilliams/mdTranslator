# HTML writer
# resource maintenance information

# History:
# 	Stan Smith 2015-03-24 original script
#   Stan Smith 2015-07-16 refactored to remove global namespace $HtmlNS

require_relative 'html_responsibleParty'

module ADIWG
    module Mdtranslator
        module Writers
            module Html

                class MdHtmlResourceMaintenance
                    def initialize(html)
                        @html = html
                    end

                    def writeHtml(hResMaint)

                        # classes used
                        htmlResParty = MdHtmlResponsibleParty.new(@html)

                        @html.section(:class=>'block') do

                            # resource maintenance - maintenance frequency
                            @html.em('Frequency: ')
                            @html.text!(hResMaint[:maintFreq])
                            @html.br

                            # resource maintenance - notes
                            aNotes = hResMaint[:maintNotes]
                            aNotes.each do |note|
                                @html.em('Note: ')
                                @html.section(:class=>'block') do
                                    @html.text!(note)
                                end
                            end

                            # resource maintenance - contacts
                            aResParty = hResMaint[:maintContacts]
                            aResParty.each do |hResParty|
                                htmlResParty.writeHtml(hResParty)
                            end

                        end

                    end # writeHtml

                end # class

            end
        end
    end
end
