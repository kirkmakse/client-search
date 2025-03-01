# ClientService:
#
# Provides business logic operations on client records, including searching by an arbitrary
# field and detecting duplicates based on a specified attribute.
#
# The search method uses Ruby's dynamic method invocation to allow flexible field-based queries,
# while the duplicate detection groups clients by the given field and returns those with multiple entries.
class ClientService
  # Initializes the service with a list of clients.
  #
  # @param clients [Array<Client>] An array of Client instances.
  def initialize(clients)
    @clients = clients
  end

  # Searches for clients by a specified field.
  #
  # Returns an array of clients whose field value (case-insensitive) contains the provided query.
  #
  # @param query [String] The search term to look for.
  # @param field [String] The attribute to search on (defaults to 'full_name').
  # @return [Array<Client>] An array of matching Client instances.
  def search(query, field = 'full_name')
    @clients.select do |client|
      value = client.send(field) rescue nil
      value&.downcase&.include?(query.downcase)
    end
  end

  # Finds duplicate client records based on a specified field.
  #
  # Groups clients by the given field and returns an array containing any duplicates (i.e., when more than
  # one client shares the same field value). Defaults to checking for duplicate emails.
  #
  # @param field [String] The attribute to check for duplicates (defaults to 'email').
  # @return [Array<Client>] An array of Client instances that are duplicates.
  def find_duplicates(field = 'email')
    grouped = @clients.group_by { |client| client.send(field) }
    grouped.select { |_, group| group.size > 1 }.values.flatten
  end
end
