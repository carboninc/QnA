shared_examples_for 'Login user' do
  it 'login user' do
    expect(subject.current_user).to eq user
  end
end

shared_examples_for 'Does not login user' do
  it 'does not login user' do
    expect(subject.current_user).to_not be
  end
end

shared_examples_for 'Redirect to root path' do
  it 'redirects to root path' do
    expect(response).to redirect_to root_path
  end
end
