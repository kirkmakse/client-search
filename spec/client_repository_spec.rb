require 'tempfile'
require_relative '../client'
require_relative '../client_repository'

RSpec.describe ClientRepository do
  let(:valid_json) do
    <<-JSON
      [
        {"id": 1, "full_name": "John Doe", "email": "john.doe@example.com"},
        {"id": 2, "full_name": "Jane Doe", "email": "jane.doe@example.com"}
      ]
    JSON
  end

  context 'with a valid JSON file' do
    it 'loads clients correctly' do
      file = Tempfile.new(['clients', '.json'])
      file.write(valid_json)
      file.rewind

      repository = ClientRepository.new(file.path)
      clients = repository.all

      expect(clients.size).to eq(2)
      expect(clients.first).to have_attributes(
                                 id: 1,
                                 full_name: 'John Doe',
                                 email: 'john.doe@example.com'
                               )
      expect(clients.last).to have_attributes(
                                id: 2,
                                full_name: 'Jane Doe',
                                email: 'jane.doe@example.com'
                              )

      file.close
      file.unlink
    end
  end

  context 'when the JSON file does not exist' do
    it 'exits with an error message' do
      non_existent_file = 'non_existent_file.json'
      expect {
        expect {
          ClientRepository.new(non_existent_file)
        }.to raise_error(SystemExit) { |e| expect(e.status).to eq(1) }
      }.to output(/Error: File 'non_existent_file\.json' does not exist\./).to_stdout
    end
  end

  context 'when the JSON file contains invalid JSON' do
    it 'exits with an error message' do
      file = Tempfile.new(['invalid', '.json'])
      file.write('not valid json')
      file.rewind

      expect {
        expect {
          ClientRepository.new(file.path)
        }.to raise_error(SystemExit) { |e| expect(e.status).to eq(1) }
      }.to output(/Error: The file '#{Regexp.escape(file.path)}' contains invalid JSON\./).to_stdout

      file.close
      file.unlink
    end
  end

  context 'when the file is not readable' do
    it 'exits with an error message' do
      file = Tempfile.new(['unreadable', '.json'])
      file.write(valid_json)
      file.rewind
      file_path = file.path
      file.close

      # Change file permissions to make it unreadable.
      File.chmod(0000, file_path)

      expect {
        expect {
          ClientRepository.new(file_path)
        }.to raise_error(SystemExit) { |e| expect(e.status).to eq(1) }
      }.to output(/Error: File '#{Regexp.escape(file_path)}' cannot be read due to insufficient permissions\./).to_stdout

      # Reset permissions for cleanup.
      File.chmod(0644, file_path)
      File.delete(file_path)
    end
  end
end
