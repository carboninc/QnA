# frozen_string_literal: true

module OmniauthMacros
  def mock_auth_hash_github
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new(
      provider: 'github',
      uid: '123456',
      info: { email: 'new@mail.com' },
      credentials: {
        token: 'mock_token',
        secret: 'mock_secret'
      }
    )
  end

  def mock_auth_hash_vkontakte
    OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new(
      provider: 'vkontakte',
      uid: '123456',
      info: { email: 'new@mail.com' },
      credentials: {
          token: 'mock_token',
          secret: 'mock_secret'
      }
    )
  end
end
