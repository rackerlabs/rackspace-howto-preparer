
require 'spec_helper'


describe KCPreparer::Document do

  before(:each) do
    @path = '/path/to/file'
    @config = mock('KCPreparer::Config')
  end

  describe "parse" do
    it "should render the content as markdown" do
      document = KCPreparer::Document.new(@config, Fixtures::DOCUMENT)
      expect(document.contents).to include("<strong>Hai</strong>")
    end

    it "should parse the metadata from yaml" do
      document = KCPreparer::Document.new(@config, Fixtures::DOCUMENT)
      expect(document.metadata.keys).to include('foo')
      expect(document.metadata['foo']).to include('bar')
    end

    it "should handle blank content" do
      document = KCPreparer::Document.new(@config, Fixtures::BLANK_DOCUMENT)
      expect(document.contents).to be_empty
    end

    it "should throw error if title does not exist" do
      expect {
        KCPreparer::Document.new(@config, Fixtures::DOCUMENT_NO_TITLE)
      }.to raise_error(ArgumentError)
    end

    it "should throw error if path does not exist" do
      expect {
        KCPreparer::Document.new(@config, Fixtures::DOCUMENT_NO_PATH)
      }.to raise_error(ArgumentError)
    end
  end

  describe "to_envelope" do
    it "should not include the fields with special meaning in the metadata" do
      document = KCPreparer::Document.new(@config, Fixtures::DOCUMENT)
      expect(document.to_envelope['metadata'].keys).not_to include('title')
      expect(document.to_envelope['metadata'].keys).not_to include('permalink')
    end
  end
end


module Fixtures

DOCUMENT = <<-EOS
---
title: Document Title
permalink: /path/to/file
foo: bar
---
**Hai**
EOS

BLANK_DOCUMENT = <<-EOS
---
title: Document Title
permalink: /path/to/file
---
EOS

DOCUMENT_NO_TITLE = <<-EOS
---
permalink: /path/to/file
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
permalink: /path/to/file
html: true
---
<b>hai</b>
EOS

end
