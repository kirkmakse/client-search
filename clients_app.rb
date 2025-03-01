#!/usr/bin/env ruby
#
# This script manages client data using JSON input. It processes client
# information from a provided JSON file and performs various operations
# such as reading, parsing, and searching client records.
#
# Example usage:
#   ./clients_app.rb -f clients.json -s Jane
#
# Command-line Options:
# ./clients_app.rb --help
# Usage: clients_app.rb [options]
#     -f, --file FILE                  JSON file with clients
#     -s, --search QUERY               Search query
#         --field FIELD                Field to search on (default: full_name)
#     -d, --duplicates                 Find duplicate emails
#
# Dependencies:
#   - Requires Ruby 3.x or higher.
#   - Uses the 'optparse' library for command-line argument parsing.
#   - Expects a properly formatted JSON file.
#
# Example JSON file structure:
# [
#   { "id": 1, "name": "John Doe", "email": "john@example.com" },
#   { "id": 2, "name": "Jane Smith", "email": "jane@example.com" }
# ]
#
require 'optparse'
require_relative 'client'
require_relative 'client_repository'
require_relative 'client_service'

# Command-line interface logic
if __FILE__ == $PROGRAM_NAME
  options = {}
  OptionParser.new do |opts|
    opts.banner = 'Usage: clients_app.rb [options]'

    opts.on('-f', '--file FILE', 'JSON file with clients') do |f|
      options[:file] = f
    end

    opts.on('-s', '--search QUERY', 'Search query') do |s|
      options[:search] = s
    end

    opts.on('--field FIELD', 'Field to search on (default: full_name)') do |field|
      options[:field] = field
    end

    opts.on('-d', '--duplicates', 'Find duplicate emails') do |_d|
      options[:duplicates] = true
    end
  end.parse!

  # Use default file if not provided
  file_path = options[:file] || 'clients.json'
  repository = ClientRepository.new(file_path)
  service = ClientService.new(repository.all)

  if options[:search]
    results = service.search(options[:search], options[:field] || 'full_name')
    if results.empty?
      puts "No clients found matching '#{options[:search]}' in field '#{options[:field] || 'full_name'}'."
    else
      puts 'Found clients:'
      results.each { |client| puts client.to_hash }
    end
  elsif options[:duplicates]
    duplicates = service.find_duplicates('email')
    if duplicates.empty?
      puts 'No duplicate emails found.'
    else
      puts 'Duplicate emails found:'
      duplicates.each { |client| puts client.to_hash }
    end
  else
    puts 'No valid command provided. Use --help for usage instructions.'
  end
end
