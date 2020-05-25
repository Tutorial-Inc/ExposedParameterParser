require 'rspec'
require_relative '../js_variable_parser'

RSpec.describe JSVariableParser do 
  context "when 'moment().format('YYYY-MM-DD')'" do
    let(:js) { "moment().format('YYYY-MM-DD')" }
    it "detects moment" do 
      expect(JSVariableParser.new(js).variables).to eq(["moment"])
    end
  end

  context "when 'moment().format('YYYY-MM-DD') + hoge'" do
    let(:js) { "moment().format('YYYY-MM-DD') + hoge" }
    it "detects [moment, hoge]" do 
      expect(JSVariableParser.new(js).variables).to eq(["moment", "hoge"])
    end
  end

  context "when 'moment().format('YYYY-MM-DD') + 123'" do
    let(:js) { "moment().format('YYYY-MM-DD') + 123" }
    it "detects [moment]" do 
      expect(JSVariableParser.new(js).variables).to eq(["moment"])
    end
  end

  context "when 'moment().format(format)'" do
    let(:js) { "moment().format(format)" }
    it "detects [moment, format]"
  end

  context "when 'css + hoge'" do
    let(:js) { "css + hoge" }
    it "detects [css, hoge]" do 
      expect(JSVariableParser.new(js).variables).to eq(["css", "hoge"])
    end
  end

  context "when 'css + 'hoge''" do
    let(:js) { "css + 'hoge'" }
    it "detects [css]" do 
      expect(JSVariableParser.new(js).variables).to eq(["css"])
    end
  end

  context "when 'value === 'hoge''" do
    let(:js) { "value === 'hoge'" }
    it "detects [value]" do 
      expect(JSVariableParser.new(js).variables).to eq(["value"])
    end
  end

  context "when 'css + 123" do
    let(:js) { "css + 123" }
    it "detects [css]" do 
      expect(JSVariableParser.new(js).variables).to eq(["css"])
    end
  end

  context "when 'css + 123.123" do
    let(:js) { "css + 123.123" }
    it "detects [css]" do 
      expect(JSVariableParser.new(js).variables).to eq(["css"])
    end
  end

  context "when 'hoge[index]" do
    let(:js) { "hoge[index]" }
    it "detects [hoge, index]" do 
      expect(JSVariableParser.new(js).variables).to eq(["hoge", "index"])
    end
  end
end
