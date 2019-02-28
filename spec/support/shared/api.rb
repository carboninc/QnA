shared_examples_for 'Return list of object' do
  it 'returns list of objects' do
    expect(object.size).to eq count
  end
end

shared_examples_for 'Return public field' do
  it 'returns all public fields' do
    array.each do |attr|
      expect(json_object[attr]).to eq object.send(attr).as_json
    end
  end
end

shared_examples_for 'Does not return private fields' do
  it 'does not return private fields' do
    array.each do |attr|
      expect(json_object).to_not have_key(attr)
    end
  end
end

shared_examples_for 'Check short title' do
  it 'contains short title' do
    expect(json_object['short_title']).to eq object.title.truncate(7)
  end
end