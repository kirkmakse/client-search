# Client Search CLI Application

## Overview

This minimalist Ruby command-line application loads a JSON dataset of client records and provides two main features:

1. **Search Clients:** Find clients with a partial match (case-insensitive search) on a specified field (default is `full_name`).
2. **Find Duplicates:** Identify clients with duplicate email addresses.

The code is designed with modularity in mind, making it easy to extend.

## File Structure

- **`clients_app.rb`:** Main CLI application that parses command-line options and executes commands.
- **`client.rb`:** Defines the `Client` class (the domain model).
- **`client_repository.rb`:** Handles loading and parsing the JSON file into `Client` objects.
- **`client_service.rb`:** Contains the business logic for searching and duplicate detection.
- **`clients.json`:** Example dataset of client records.
- **`spec/clients_spec.rb`:** RSpec tests to verify the application functionality.

## Prerequisites

- Ruby (version 3.4.2 or higher is recommended). Use [this guide](https://gorails.com/setup/macos/15-sequoia) to install Ruby if needed. 
- (Optional) Bundler for managing Ruby gems
- (Optional) RSpec for running tests

## Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/kirkmakse/client-search.git
   cd client-search
   ```
   
2. **Install Dependencies**: If you are using Bundler, run:
   ```bash
   bundle install
   ```
   Otherwise, install the required gems manually:
      ```bash
   gem install rspec
   ```
   
## Usage

The application supports the following command-line options:

- `-f`, `--file FILE`<br>
  Specify the JSON file with clients (defaults to `clients.json`).

- `-s`, `--search QUERY`<br>
  Provide a search query string for matching client records (case-insensitive search).

- `--field FIELD`<br>
  Specify the field to search on (default is `full_name`).<br>
  **Note**: Use this option only for specifying the search field.

- `-d`, `--duplicates`<br>
  Check for duplicate emails in the dataset.

## Usage Examples

1. **Usage and Options**<br>
   ```bash
   ./clients_app.rb
   ```
   **Expected Output**:
   ```text
   No valid command provided. Use --help for usage instructions.
   ```
      ```bash
   ./clients_app.rb --help
   ```
   **Expected Output**:
   ```text
    Usage: clients_app.rb [options]
    -f, --file FILE                  JSON file with clients
    -s, --search QUERY               Search query
        --field FIELD                Field to search on (default: full_name)
    -d, --duplicates                 Find duplicate emails
   ```

2. **Search by Full Name (Default Field)**<br>
   Search for clients with a name that contains "Jane":

    ```bash
    ./clients_app.rb -f clients.json -s Jane
    ```
    **Expected Output**:
    ```text
    Found clients:
    {:id=>2, :full_name=>"Jane Smith", :email=>"jane.smith@yahoo.com"}
    {:id=>15, :full_name=>"Another Jane Smith", :email=>"jane.smith@yahoo.com"}
   ```

3. **Search by Email**<br>
   Search for clients with emails containing "fastmail":

    ```bash
    ./clients_app.rb -f clients.json -s fastmail --field email
    ```
    **Expected Output**:
    ```text
    Found clients:
    {:id=>13, :full_name=>"Liam Martinez", :email=>"liam.martinez@fastmail.fm"}
    ```

4. **Find Duplicate Emails**<br>
    Identify clients with duplicate email addresses:

    ```bash
    ./clients_app.rb -f clients.json -d
    ```
    **Expected Output**:
    ```text
    Duplicate emails found:
    {:id=>2, :full_name=>"Jane Smith", :email=>"jane.smith@yahoo.com"}
    {:id=>15, :full_name=>"Another Jane Smith", :email=>"jane.smith@yahoo.com"}
    ```

## Running Tests
To run the test suite with RSpec:

1. Ensure you have the rspec gem installed:
   ```bash
   gem install rspec
   ```
   
2. Run the tests:
   ```bash
   rspec
   ```

## Future Enhancements

- **Dynamic JSON Input - Done**: Currently, you can specify any JSON file using the -f option.
- **Dynamic Search Fields - Done** : The `--field` option allows users to search by any attribute.
- **REST API Integration**: Future versions could expose similar functionality via a RESTful API endpoint using Sinatra.
- **Scalability**: Use a database, indexing, and caching to support larger datasets and separate into load and query operations.
