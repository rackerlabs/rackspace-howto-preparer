
require 'spec_helper'


describe KCPreparer::Document do

  before(:each) do
    @path = '/path/to/file'
    @config = mock('KCPreparer::Config')
  end

  describe "parse" do
    it "should render the content as markdown" do
      IO.expects(:read).with(@path).returns(Fixtures::DOCUMENT)
      expect(document.contents).to include("<strong>Hai</strong>")
    end

    it "should parse the metadata from yaml" do
      IO.expects(:read).times(2).with(@path).returns(Fixtures::DOCUMENT)
      expect(document.metadata.keys).to include('foo')
      expect(document.metadata['foo']).to include('bar')
    end

    it "should handle blank content" do
      IO.expects(:read).with(@path).returns(Fixtures::BLANK_DOCUMENT)
      expect(document.contents).to be_empty
    end

    it "should throw error if title does not exist" do
      IO.expects(:read).with(@path).returns(Fixtures::DOCUMENT_NO_TITLE)
      expect { document }.to raise_error(ArgumentError)
    end

    it "should throw error if path does not exist" do
      IO.expects(:read).with(@path).returns(Fixtures::DOCUMENT_NO_PATH)
      expect { document }.to raise_error(ArgumentError)
    end

    it "should not call parse_contents() when the document is marked as html" do
      IO.expects(:read).with(@path).returns(Fixtures::DOCUMENT_HTML)
      document = KCPreparer::Document.new(@config, @path)
      document.expects(:parse_contents).never
      document.parse
    end
  end

  describe "to_envelope" do
    it "should not include the fields with special meaning in the metadata" do
      IO.expects(:read).times(2).with(@path).returns(Fixtures::DOCUMENT)
      expect(document.to_envelope['meta'].keys).not_to include('title')
      expect(document.to_envelope['meta'].keys).not_to include('path')
    end
  end

  def document
    document = KCPreparer::Document.new(@config, @path)
    document.parse
    document
  end
end


module Fixtures

DOCUMENT = <<-EOS
---
title: Document Title
path: /path/to/file
foo: bar
---
**Hai**
EOS

BLANK_DOCUMENT = <<-EOS
---
title: Document Title
path: /path/to/file
---
EOS

DOCUMENT_NO_TITLE = <<-EOS
---
path: /path/to/file
---
EOS

DOCUMENT_NO_PATH = <<-EOS
---
title: Document Title
---
EOS

DOCUMENT_HTML = <<-EOS
---
title: Foo
path: /path/to/file
html: true
---
<b>hai</b>
EOS

end
