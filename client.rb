# Client: Represents an individual client record.
#
# This class encapsulates the properties of a client, including the client's
# unique identifier, full name, and email address. It provides a simple interface
# to access these attributes and a method to represent the client as a hash,
# facilitating integration with other components of the application.
class Client
  attr_reader :id, :full_name, :email

  # Initializes a new Client instance.
  #
  # @param attrs [Hash] a hash containing the client's data with keys:
  #   - "id": The unique identifier for the client.
  #   - "full_name": The client's full name.
  #   - "email": The client's email address.
  def initialize(attrs)
    @id = attrs["id"]
    @full_name = attrs["full_name"]
    @email = attrs["email"]
  end

  # Returns the client's attributes as a hash.
  #
  # @return [Hash] a hash representation of the client with keys :id, :full_name, and :email.
  def to_hash
    { id: @id, full_name: @full_name, email: @email }
  end
end
