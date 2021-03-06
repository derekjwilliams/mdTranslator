# ISO <<Class>> Multi Geometry
# writer output in XML

# History:
# 	Stan Smith 2013-11-12 original script.
# 	Stan Smith 2013-11-13 add line string
#   Stan Smith 2014-05-30 modified for version 0.5.0
#   Stan Smith 2014-07-08 modify require statements to function in RubyGem structure
#   Stan Smith 2014-12-12 refactored to handle namespacing readers and writers
#   Stan Smith 2015-06-22 replace global ($response) with passed in object (responseObj)
#   Stan Smith 2015-07-14 refactored to make iso19110 independent of iso19115_2 classes
#   Stan Smith 2015-07-14 refactored to eliminate namespace globals $WriterNS and $IsoNS

require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_point')
require ADIWG::Mdtranslator::Readers::MdJson.readerModule('module_lineString')
require_relative 'class_point'
require_relative 'class_lineString'
require_relative 'class_polygon'

module ADIWG
    module Mdtranslator
        module Writers
            module Iso19115_2

                class MultiGeometry

                    def initialize(xml, responseObj)
                        @xml = xml
                        @responseObj = responseObj
                    end

                    def writeXML(hGeoElement)

                        # classes used
                        intMetadataClass = InternalMetadata.new
                        pointClass =  Point.new(@xml, @responseObj)
                        lineClass =  LineString.new(@xml, @responseObj)
                        polygonClass =  Polygon.new(@xml, @responseObj)


                        # gml:MultiGeometry attributes
                        attributes = {}

                        # gml:MultiGeometry attributes - gml:id - required
                        mGeoID = hGeoElement[:elementId]
                        if mGeoID.nil?
                            @responseObj[:writerMissingIdCount] = @responseObj[:writerMissingIdCount].succ
                            mGeoID = 'multiGeo' + @responseObj[:writerMissingIdCount]
                        end
                        attributes['gml:id'] = mGeoID

                        # gml:MultiGeometry attributes - srsDimension
                        s = hGeoElement[:elementGeometry][:dimension]
                        if !s.nil?
                            attributes[:srsDimension] = s
                        end

                        # gml:MultiGeometry attributes - srsName
                        s = hGeoElement[:elementSrs][:srsName]
                        if !s.nil?
                            attributes[:srsName] = s
                        end

                        @xml.tag!('gml:MultiGeometry', attributes) do

                            # multi geometry - description
                            s = hGeoElement[:elementDescription]
                            if !s.nil?
                                @xml.tag!('gml:description', s)
                            elsif @responseObj[:writerShowTags]
                                @xml.tag!('gml:description')
                            end

                            # multi geometry - name
                            s = hGeoElement[:elementName]
                            if !s.nil?
                                @xml.tag!('gml:name', s)
                            elsif @responseObj[:writerShowTags]
                                @xml.tag!('gml:name')
                            end

                            # GeoJSON multi-objects need to be broken into independent
                            # ... geometry members for ISO representation
                            geoType = hGeoElement[:elementGeometry][:geoType]
                            case geoType
                                when 'MultiPoint'
                                    aPoints = hGeoElement[:elementGeometry][:geometry]
                                    if !aPoints.empty?
                                        @xml.tag!('gml:geometryMembers') do
                                            aPoints.each do |aCoords|
                                                intPoint = intMetadataClass.newGeoElement
                                                intPoint[:elementSrs] = hGeoElement[:elementSrs]
                                                intPoint[:elementGeometry] = ADIWG::Mdtranslator::Readers::MdJson::Point.unpack(aCoords, 'Point', @responseObj)
                                                pointClass.writeXML(intPoint)
                                            end
                                        end
                                    end
                                when 'MultiLineString'
                                    aLines = hGeoElement[:elementGeometry][:geometry]
                                    if !aLines.empty?
                                        @xml.tag!('gml:geometryMembers') do
                                            aLines.each do |aCoords|
                                                intLine = intMetadataClass.newGeoElement
                                                intLine[:elementSrs] = hGeoElement[:elementSrs]
                                                intLine[:elementGeometry] = ADIWG::Mdtranslator::Readers::MdJson::LineString.unpack(aCoords, 'LineString', @responseObj)
                                                lineClass.writeXML(intLine)
                                            end
                                        end
                                    end
                                when 'MultiPolygon'
                                    aPolygons = hGeoElement[:elementGeometry][:geometry]
                                    if !aPolygons.empty?
                                        @xml.tag!('gml:geometryMembers') do
                                            aPolygons.each do |aCoords|
                                                intPolygon = intMetadataClass.newGeoElement
                                                intPolygon[:elementSrs] = hGeoElement[:elementSrs]
                                                intPolygon[:elementGeometry] = ADIWG::Mdtranslator::Readers::MdJson::LineString.unpack(aCoords, 'Polygon', @responseObj)
                                                polygonClass.writeXML(intPolygon)
                                            end
                                        end
                                    end
                            end

                            # multi geometry - geometry members
                            # GeoJSON GeometryCollection
                            # GeoJSON FeatureCollection
                            case geoType
                                when 'MultiGeometry'
                                    aGeometry = hGeoElement[:elementGeometry][:geometry]
                                    if !aGeometry.empty?
                                        @xml.tag!('gml:geometryMembers') do
                                            aGeometry.each do |hGeometry|
                                                hGeoType = hGeometry[:elementGeometry][:geoType]
                                                case hGeoType
                                                    when 'Point'
                                                        pointClass.writeXML(hGeometry)
                                                    when 'LineString'
                                                        lineClass.writeXML(hGeometry)
                                                    when 'Polygon'
                                                        polygonClass.writeXML(hGeometry)
                                                end
                                            end
                                        end
                                    end
                            end

                        end

                    end

                end

            end
        end
    end
end
