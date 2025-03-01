require_relative '../clients_app'
require 'rspec'

RSpec.describe ClientService do
  let(:clients_data) do
    [
      {"id" => 1, "full_name" => "John Doe", "email" => "john.doe@gmail.com"},
      {"id" => 2, "full_name" => "Jane Smith", "email" => "jane.smith@yahoo.com"},
      {"id" => 3, "full_name" => "Another Jane Smith", "email" => "jane.smith@yahoo.com"}
    ]
  end

  let(:clients) { clients_data.map { |attrs| Client.new(attrs) } }
  subject { ClientService.new(clients) }

  describe "#search" do
    it "returns clients with partial name match" do
      results = subject.search("Jane", "full_name")
      expect(results.map(&:full_name)).to include("Jane Smith", "Another Jane Smith")
    end

    it "returns an empty array when no match is found" do
      results = subject.search("Nonexistent", "full_name")
      expect(results).to be_empty
    end
  end

  describe "#find_duplicates" do
    it "returns duplicate email clients" do
      duplicates = subject.find_duplicates("email")
      duplicate_emails = duplicates.map(&:email)
      expect(duplicate_emails.count("jane.smith@yahoo.com")).to eq(2)
    end

    it "returns an empty array if there are no duplicates" do
      unique_clients = clients.reject { |c| c.email == "jane.smith@yahoo.com" }
      service = ClientService.new(unique_clients)
      duplicates = service.find_duplicates("email")
      expect(duplicates).to be_empty
    end
  end
end
