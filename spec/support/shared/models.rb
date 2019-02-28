shared_examples_for 'Check many attached files' do
  it 'have many attached files' do
    expect(object.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end