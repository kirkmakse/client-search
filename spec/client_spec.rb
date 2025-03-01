require_relative '../client'

RSpec.describe Client do
  id = 1
  full_name = "John Doe"
  email = "john.doe@example.com"

  let(:attributes) do
    { "id" => id, "full_name" => full_name, "email" => email }
  end

  subject { Client.new(attributes) }

  describe '#initialize' do
    it 'assigns the id correctly' do
      expect(subject.id).to eq(id)
    end

    it 'assigns the full_name correctly' do
      expect(subject.full_name).to eq(full_name)
    end

    it 'assigns the email correctly' do
      expect(subject.email).to eq(email)
    end
  end

  describe '#to_hash' do
    it 'returns a hash with the correct keys and values' do
      expected_hash = { id: id, full_name: full_name, email: email }
      expect(subject.to_hash).to eq(expected_hash)
    end
  end
end
