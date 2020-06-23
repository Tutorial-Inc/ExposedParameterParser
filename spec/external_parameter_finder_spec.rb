require 'rspec'
require_relative '../lib/external_parameter_finder'

RESERVED_VARIABLES = [
  'PROJECT_ID',
  'WORKFLOW_ID',
  'SESSION_QUEUE_ID',
  'SESSION_TIME',
  'EXEC_PARAMS',
]

STANDARD_LIBRARIES = [
  'moment'
]

predefined_parameters = RESERVED_VARIABLES + STANDARD_LIBRARIES

RSpec.describe ExternalParameterFinder do

  context "when parse wantedly scout dry run yaml" do 
    context "when block not given" do 
      it "detects username, password, url, limit, automation_id, webhookUrl" do 
        parser = ExternalParameterFinder.new(predefined_parameters)
        yaml = File.open('./spec/resource/wantedly_scout_dry_run.yaml')
        params = parser.parse yaml
        expect(params.map { |el| el[:paramName] }).to eq([
          "username", "password", "url", "limit", "automation_id", "webhookUrl"
        ])
      end
    end

    context "when block is given" do 
      it "detects username, password, url, limit, automation_id, webhookUrl processed with a given block" do 
        parser = ExternalParameterFinder.new(predefined_parameters)
        yaml = File.open('./spec/resource/wantedly_scout_dry_run.yaml')
        params = parser.parse yaml do |param_name|
          { hoge: param_name }
        end
        expect(params).to eq([
          { hoge: "username"}, 
          { hoge: "password"},
          { hoge: "url" },
          { hoge: "limit"},
          { hoge: "automation_id"},
          { hoge: "webhookUrl"},
        ])
      end
    end

  end

  context "when parse wantedly scout send scout yaml" do 
    it "detects username, password, offer, url, limit, template, automation_id, webhookUrl" do 
      parser = ExternalParameterFinder.new(predefined_parameters)
      yaml = File.open('./spec/resource/wantedly_scout.yaml')
      params = parser.parse yaml
      expect(params.map { |el| el[:paramName] }).to eq([
        "username", "password", "offer", "url", "limit", "template", "automation_id", "webhookUrl"
      ])
    end
  end

  context "when parse wantedly scout send scout yaml with predefined username and password" do 
    it "detects offer, url, limit, template, automation_id, webhookUrl" do
      parser = ExternalParameterFinder.new(["username", "password"] + predefined_parameters)
      yaml = File.open('./spec/resource/wantedly_scout.yaml')
      params = parser.parse yaml
      expect(params.map { |el| el[:paramName] }).to eq([
        "offer", "url", "limit", "template", "automation_id", "webhookUrl"
      ])
    end
  end

  context "when intercom api workfor" do 
    it "detects token" do 
      parser = ExternalParameterFinder.new(predefined_parameters)
      yaml = File.open('./spec/resource/intercom_api.yaml')
      params = parser.parse yaml
      expect(params.map { |el| el[:paramName] }).to eq([
        "token"
      ])
    end
  end

  context "when line api workflow" do 
    it "detects token" do 
      parser = ExternalParameterFinder.new(predefined_parameters)
      yaml = File.open('./spec/resource/line_api.yaml')
      params = parser.parse yaml
      expect(params.map { |el| el[:paramName] }).to eq([
        "user_id", "url"
      ])
    end
  end

  context "when seminarshelf to slack workflow" do 
    it "detects minutes, gmailProvider, slackProvider" do 
      parser = ExternalParameterFinder.new(predefined_parameters)
      yaml = File.open('./spec/resource/seminar_shelf_to_slack.yaml')
      params = parser.parse yaml
      expect(params.map { |el| el[:paramName] }).to eq([
        "minutes", "gmailProvider", "slackProvider"
      ])
    end
  end

  context "when wantedly scoutlist workflow" do 
    it "detects email, password, queryId, spreadsheetProvider, sheetId" do 
      parser = ExternalParameterFinder.new(predefined_parameters)
      yaml = File.open('./spec/resource/wantedly_scout_list.yaml')
      params = parser.parse yaml
      expect(params.map { |el| el[:paramName] }).to eq([
        "queryId", "spreadsheetProvider", "sheetId", "email", "password"
      ])
    end
  end

end

