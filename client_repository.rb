require 'json'

# ClientRepository:
#
# Responsible for loading client data from a JSON file and converting it into
# Client objects. This class abstracts the data access layer, enabling the rest
# of the application to work with client records without concerning itself with
# the specifics of JSON file parsing.
class ClientRepository
  # Initializes the repository and loads clients from the specified JSON file.
  #
  # @param file_path [String] The path to the JSON file containing client data.
  def initialize(file_path)
    @clients = load_clients(file_path)
  end

  # Returns all loaded client objects.
  #
  # @return [Array<Client>] An array of Client instances.
  def all
    @clients
  end

  private

    # Loads and parses the JSON file, converting each record into a Client object.
    #
    # If the file cannot be read or the JSON is invalid, an error message is displayed
    # and the application exits.
    #
    # @param file_path [String] The path to the JSON file.
    # @return [Array<Client>] An array of Client objects.
    def load_clients(file_path)
      file_content = begin
                       File.read(file_path)
                     rescue Errno::ENOENT
                       puts "Error: File '#{file_path}' does not exist."
                       exit 1
                     rescue Errno::EACCES
                       puts "Error: File '#{file_path}' cannot be read due to insufficient permissions."
                       exit 1
                     end

      data = begin
               JSON.parse(file_content)
             rescue JSON::ParserError
               puts "Error: The file '#{file_path}' contains invalid JSON."
               exit 1
             end

      data.map { |attrs| Client.new(attrs) }
    end
end
