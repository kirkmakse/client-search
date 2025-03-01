require 'open3'
require 'tempfile'

RSpec.describe 'clients_app.rb CLI' do
  let(:app_path) { File.expand_path('../../clients_app.rb', __FILE__) }
  let(:json_content) do
    <<-JSON
    [
      {"id": 1, "full_name": "John Doe", "email": "john.doe@example.com"},
      {"id": 2, "full_name": "Jane Smith", "email": "jane.smith@example.com"},
      {"id": 3, "full_name": "Another Jane Smith", "email": "jane.smith@example.com"}
    ]
    JSON
  end

  # Helper method to run the CLI with given arguments
  def run_app(args)
    Open3.capture3("ruby #{app_path} #{args}")
  end

  context 'when searching for clients' do
    it 'outputs matching clients for a valid search query' do
      Tempfile.open(['clients', '.json']) do |file|
        file.write(json_content)
        file.rewind

        stdout, _stderr, status = run_app("-f #{file.path} -s Jane")
        expect(stdout).to include("Found clients:")
        expect(stdout).to include("Jane Smith")
        expect(stdout).to include("Another Jane Smith")
        expect(status.exitstatus).to eq(0)
      end
    end

    it 'outputs a message when no matching clients are found' do
      Tempfile.open(['clients', '.json']) do |file|
        file.write(json_content)
        file.rewind

        stdout, _stderr, status = run_app("-f #{file.path} -s Nonexistent")
        expect(stdout).to include("No clients found matching 'Nonexistent'")
        expect(status.exitstatus).to eq(0)
      end
    end
  end

  context 'when finding duplicates' do
    it 'outputs duplicate emails when found' do
      Tempfile.open(['clients', '.json']) do |file|
        file.write(json_content)
        file.rewind

        stdout, _stderr, status = run_app("-f #{file.path} -d")
        expect(stdout).to include("Duplicate emails found:")
        expect(stdout).to include("jane.smith@example.com")
        expect(status.exitstatus).to eq(0)
      end
    end

    it 'outputs a message when no duplicate emails are found' do
      json_no_duplicates = <<-JSON
      [
        {"id": 1, "full_name": "John Doe", "email": "john.doe@example.com"},
        {"id": 2, "full_name": "Jane Smith", "email": "jane.smith@example.com"}
      ]
      JSON

      Tempfile.open(['clients', '.json']) do |file|
        file.write(json_no_duplicates)
        file.rewind

        stdout, _stderr, status = run_app("-f #{file.path} -d")
        expect(stdout).to include("No duplicate emails found.")
        expect(status.exitstatus).to eq(0)
      end
    end
  end

  context 'when no valid command is provided' do
    it 'outputs a help message' do
      Tempfile.open(['clients', '.json']) do |file|
        file.write(json_content)
        file.rewind

        stdout, _stderr, status = run_app("-f #{file.path}")
        expect(stdout).to include("No valid command provided. Use --help for usage instructions.")
        expect(status.exitstatus).to eq(0)
      end
    end
  end
end
