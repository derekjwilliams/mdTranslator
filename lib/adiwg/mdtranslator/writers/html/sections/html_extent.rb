# HTML writer
# extents (geographic, temporal, vertical)

# History:
# 	Stan Smith 2015-03-31 original script

require 'html_geographicElement'
require 'html_temporalElement'
require 'html_verticalElement'

module ADIWG
    module Mdtranslator
        module Writers
            module Html

                class MdHtmlExtent
                    def initialize(html)
                        @html = html
                    end

                    def writeHtml(hExtent, extNum)

                        # classes used
                        htmlGeoEle = $HtmlNS::MdHtmlGeographicElement.new(@html)
                        htmlTempEle = $HtmlNS::MdHtmlTemporalElement.new(@html)
                        htmlVertEle = $HtmlNS::MdHtmlVerticalElement.new(@html)

                        aGeoEle = hExtent[:extGeoElements]
                        aTempEle = hExtent[:extTempElements]
                        aVertEle = hExtent[:extVertElements]

                        # extent - description
                        s = hExtent[:extDesc]
                        if !s.nil?
                            @html.em('Extent description: ')
                            @html.section(:class=>'block') do
                                @html.text!(s)
                            end
                        end

                        # extent - map
                        @html.details do
                            @html.summary('Map', {'class'=>'h4'})
                            @html.div('class'=>'map') do

                            end
                        end

                        # extent - geographic elements
                        if !aGeoEle.empty?
                            @html.details do
                                @html.summary('Geographic Elements', {'class'=>'h4'})
                                geoNum = 0
                                aGeoEle.each do |hGeoEle|
                                    @html.section(:class=>'block') do
                                        @html.details do
                                            eleNum = extNum.to_s + '.' + geoNum.to_s
                                            @html.summary('Element ' + eleNum, {'class'=>'h5 element'})
                                            @html.section(:class=>'block') do
                                                htmlGeoEle.writeHtml(hGeoEle, eleNum)
                                                geoNum += 1
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        # extent - vertical elements
                        if !aVertEle.empty?
                            @html.details do
                                @html.summary('Vertical Elements', {'class'=>'h4'})
                                vertNum = 0
                                aVertEle.each do |hVertEle|
                                    @html.section(:class=>'block') do
                                        @html.details do
                                            eleNum = extNum.to_s + '.' + vertNum.to_s
                                            @html.summary('Element ' + eleNum, {'class'=>'h5'})
                                            @html.section(:class=>'block') do
                                                htmlVertEle.writeHtml(hVertEle)
                                                vertNum += 1
                                            end
                                        end
                                    end
                                end
                            end
                        end

                        # extent - temporal elements
                        if !aTempEle.empty?
                            @html.details do
                                @html.summary('Temporal Elements', {'class'=>'h4'})
                                aTempEle.each do |hTempEle|
                                    @html.section(:class=>'block') do
                                        htmlTempEle.writeHtml(hTempEle)
                                    end
                                end
                            end
                        end

                    end # writeHtml

                end # class

            end
        end
    end
end
