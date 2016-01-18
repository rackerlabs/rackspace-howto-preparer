
require 'spec_helper'


describe KCPreparer::Document do

  before(:each) do
    @path = '/path/to/permalink.md'
    @config = mock('KCPreparer::Config')
  end

  describe "initialize" do
    it "should render the content as markdown" do
      document = KCPreparer::Document.new(@config, nil, Fixtures::DOCUMENT)
      expect(document.contents).to include("<strong>Hai</strong>")
    end

    it "should parse the metadata from yaml" do
      document = KCPreparer::Document.new(@config, nil, Fixtures::DOCUMENT)
      expect(document.metadata.keys).to include('foo')
      expect(document.metadata['foo']).to include('bar')
    end

    it "should handle blank content" do
      document = KCPreparer::Document.new(@config, nil, Fixtures::BLANK_DOCUMENT)
      expect(document.contents).to eql("\n")
    end

    it "should throw error if document is malformed" do
      expect {
        KCPreparer::Document.new(@config, nil, Fixtures::MALFORMED_DOCUMENT)
      }.to raise_error(ArgumentError)
    end

    it "should throw error if title does not exist" do
      expect {
        KCPreparer::Document.new(@config, nil, Fixtures::DOCUMENT_NO_TITLE)
      }.to raise_error(ArgumentError)
    end
  end

  describe "to_envelope" do
    before(:each) do
      @config.stubs(:[]).with(:kc_base_url).returns('http://example.com')
    end

    it "should not include the fields with special meaning in the metadata" do
      document = KCPreparer::Document.new(@config, nil, Fixtures::DOCUMENT)
      expect(document.to_envelope['metadata'].keys).not_to include('title')
    end

    it "should add the full github path to the metadata" do
      document = KCPreparer::Document.new(@config, 'contents/foo.md', Fixtures::DOCUMENT)
      expect(document.to_envelope['metadata'].keys).to include('github_url')
      expect(document.to_envelope['metadata']['github_url']).to eql('http://example.com/edit/master/contents/foo.md')
    end
  end
end


module Fixtures

DOCUMENT = <<-EOS
---
title: Document Title
foo: bar
---
**Hai**
EOS

MALFORMED_DOCUMENT = <<-EOS
---
title: Document Title
foo: bar
**Hai**
EOS

BLANK_DOCUMENT = <<-EOS
---
title: Document Title
---
EOS

DOCUMENT_NO_TITLE = <<-EOS
---
---
EOS

DOCUMENT_HTML = <<-EOS
---
title: Foo
html: true
---
<b>hai</b>
EOS

end
