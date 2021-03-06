# MdTranslator - minitest of
# reader / mdJson / module_citation

# History:
# Stan Smith 2014-12-19 original script
# Stan Smith 2015-06-22 refactored setup to after removal of globals

# set reader version used by mdJson_reader.rb to require correct modules
module ADIWG
    module Mdtranslator
        module Readers
            module MdJson

                @responseObj = {
                    readerVersionUsed: '1.2.0'
                }

            end
        end
    end
end

require 'minitest/autorun'
require 'json'
require 'adiwg/mdtranslator/internal/internal_metadata_obj'
require 'adiwg/mdtranslator/internal/module_dateTimeFun'
require 'adiwg/mdtranslator/readers/mdJson/mdJson_reader'
require 'adiwg/mdtranslator/readers/mdJson/modules_v1/module_citation'

class TestReaderMdJsonCitation_v1 < MiniTest::Test

    # set constants and variables
    @@NameSpace = ADIWG::Mdtranslator::Readers::MdJson::Citation
    @@responseObj = {
        readerVersionUsed: '1.0',
        readerExecutionPass: true,
        readerExecutionMessages: []
    }

    # get json file for tests from examples folder
    file = File.join(File.dirname(__FILE__), '../../../', 'schemas/v1_0/examples', 'citation.json')
    file = File.open(file, 'r')
    jsonFile = file.read
    file.close
    aIn = JSON.parse(jsonFile)

    # only the first instance in the example array is used for tests
    # the first example is fully populated
    # remove responsible party from citation to prevent search for contact
    # in contact array which has not been loaded
    @@hIn = aIn[0]
    @@hIn['responsibleParty'] = []
    @@hIn['identifier'][0]['authority']['responsibleParty'] = []

    def test_complete_citation_object
        hIn = Marshal::load(Marshal.dump(@@hIn))
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_equal metadata[:citTitle], 'title'
        refute_empty metadata[:citDate]
        assert_equal metadata[:citEdition], 'edition'
        refute_empty metadata[:citResourceIds]
        assert_empty metadata[:citResponsibleParty]
        assert_equal metadata[:citResourceForms].length, 2
        assert_equal metadata[:citResourceForms][0], 'presentationForm1'
        assert_equal metadata[:citResourceForms][1], 'presentationForm2'
        refute_empty metadata[:citOlResources]
    end

    def test_empty_citation_title
        hIn = Marshal::load(Marshal.dump(@@hIn))
        hIn['title'] = ''
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        hResponse[:readerExecutionPass] = true
        hResponse[:readerExecutionMessages] = []
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_nil metadata
        refute hResponse[:readerExecutionPass]
        refute_empty hResponse[:readerExecutionMessages]
    end

    def test_missing_citation_title
        hIn = Marshal::load(Marshal.dump(@@hIn))
        hIn.delete('title')
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        hResponse[:readerExecutionPass] = true
        hResponse[:readerExecutionMessages] = []
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_nil metadata
        refute hResponse[:readerExecutionPass]
        refute_empty hResponse[:readerExecutionMessages]
    end

    def test_empty_citation_elements
        hIn = Marshal::load(Marshal.dump(@@hIn))
        hIn['date'] = []
        hIn['edition'] = ''
        hIn['presentationForm'] = []
        hIn['identifier'] = []
        hIn['onlineResource'] = []
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_equal metadata[:citTitle], 'title'
        assert_empty metadata[:citDate]
        assert_nil metadata[:citEdition]
        assert_empty metadata[:citResourceIds]
        assert_empty metadata[:citResponsibleParty]
        assert_empty metadata[:citResourceForms]
        assert_empty metadata[:citOlResources]
    end

    def test_missing_citation_elements
        hIn = Marshal::load(Marshal.dump(@@hIn))
        hIn.delete('date')
        hIn.delete('edition')
        hIn.delete('responsibleParty')
        hIn.delete('presentationForm')
        hIn.delete('identifier')
        hIn.delete('onlineResource')
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack(hIn, hResponse)

        assert_equal metadata[:citTitle], 'title'
        assert_empty metadata[:citDate]
        assert_nil metadata[:citEdition]
        assert_empty metadata[:citResourceIds]
        assert_empty metadata[:citResponsibleParty]
        assert_empty metadata[:citResourceForms]
        assert_empty metadata[:citOlResources]
    end

    def test_empty_citation_object
        hResponse = Marshal::load(Marshal.dump(@@responseObj))
        metadata = @@NameSpace.unpack({}, hResponse)

        assert_nil metadata
    end

end