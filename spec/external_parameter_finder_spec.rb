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
    it "detects username, password, url, limit, automation_id, webhookUrl" do 
      parser = ExternalParameterFinder.new(predefined_parameters)
      yaml = File.open('./spec/resource/wantedly_scout_dry_run.yaml')
      params = parser.parse yaml
      expect(params.map { |el| el[:paramName] }).to eq([
        "username", "password", "url", "limit", "automation_id", "webhookUrl"
      ])
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

end

