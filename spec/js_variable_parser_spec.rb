require 'rspec'
require_relative '../lib/exposed_parameter_parser/js_variable_parser'

RSpec.describe ExposedParameterParser::JsVariableParser do

  context "when 'comma_not\'closed'" do 
    let(:js) { "comma_not'closed" }
    it "raises error" do 
      expect { ExposedParameterParser::JsVariableParser.new(js).variables }.to raise_error(StandardError)
    end
  end

  context "when 'moment()'" do 
    let(:js) { "moment()" }
    it "detects moment" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).variables).to eq(["moment"])
    end
  end

  context "when 'moment().format('YYYY-MM-DD')'" do
    let(:js) { "moment().format('YYYY-MM-DD')" }
    it "detects moment" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).variables).to eq(["moment"])
    end

    it "detects .format function" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).functions).to eq([".format"])
    end
  end

  context "when 'moment().tz(timezone).unknownFunction().format('YYYY')'" do
    let(:js) { "moment().tz(timeZone).unknownFunction().format('YYYY')" }
    it "detects moment, timeAone" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).variables).to eq(["moment", "timeZone"])
    end

    it "detects .format function" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).functions).to eq([".tz", ".unknownFunction", ".format"])
    end
  end

  context "when 'moment().format('YYYY-MM-DD') + hoge'" do
    let(:js) { "moment().format('YYYY-MM-DD') + hoge" }
    it "detects [moment, hoge]" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).variables).to eq(["moment", "hoge"])
    end

    it "detects .format function" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).functions).to eq([".format"])
    end
  end

  context "when 'moment().format('YYYY-MM-DD') + 123'" do
    let(:js) { "moment().format('YYYY-MM-DD') + 123" }
    it "detects [moment]" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).variables).to eq(["moment"])
    end

    it "detects .format function" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).functions).to eq([".format"])
    end

  end

  context "when 'moment().format(formatStr)'" do
    let(:js) { "moment().format(formatStr)" }
    it "detects [moment, formatStr]" do
      expect(ExposedParameterParser::JsVariableParser.new(js).variables).to eq(["moment", "formatStr"])
    end
  end

  context "when 'css + hoge'" do
    let(:js) { "css + hoge" }
    it "detects [css, hoge]" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).variables).to eq(["css", "hoge"])
    end
  end

  context "when 'css + 'hoge''" do
    let(:js) { "css + 'hoge'" }
    it "detects [css]" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).variables).to eq(["css"])
    end
  end

  context "when 'value === 'hoge''" do
    let(:js) { "value === 'hoge'" }
    it "detects [value]" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).variables).to eq(["value"])
    end
  end

  context "when 'css + 123" do
    let(:js) { "css + 123" }
    it "detects [css]" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).variables).to eq(["css"])
    end
  end

  context "when 'css + 123.123" do
    let(:js) { "css + 123.123" }
    it "detects [css]" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).variables).to eq(["css"])
    end
  end

  context "when 'hoge[index]" do
    let(:js) { "hoge[index]" }
    it "detects [hoge, index]" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).variables).to eq(["hoge", "index"])
    end
  end

  # TODO: Support string literal
  context "when '`this is a ${penName}`" do 
    let(:js) { "`this is a ${penName}`" }
    it "cannot detect penName" do 
      expect(ExposedParameterParser::JsVariableParser.new(js).variables).to eq([])
    end
  end

end
