require 'spec_helper'

describe OmniauthCallbacksController do
  before(:all) { OmniAuth.config.test_mode = true }

  describe '#google_oauth2' do
    let(:callback) { get :google_oauth2 }

    before do
      OmniAuth.config.add_mock(:google_oauth2, {
        info: {
          first_name: 'Jan',
          last_name: 'Kowalski',
          email: 'jan@kowalski.pl'
        },
        extra: { raw_info: { hd: 'netguru.pl' }}
      })
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:google_oauth2]
    end

    context 'user is from netguru' do
      it 'signs up user' do
        expect { callback }.to change { User.count }.by(1)
      end

      it 'signs in user' do
        callback
        expect(controller.current_user).to eq User.last
      end

      it 'redirects to root path' do
        callback
        expect(response).to redirect_to root_path
      end
    end

    context 'user is not form netguru' do
      before do
        request.env["omniauth.auth"][:extra][:raw_info][:hd] = 'example.com'
      end

      it "doesn't signs up user" do
        expect { callback }.to_not change { User.count }
      end

      it "doesn't signs in user" do
        callback
        expect(controller.current_user).to be_nil
      end

      it 'redirects to root path' do
        callback
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#github' do
    let(:callback) { get :github }
    let(:user) { create(:user, gh_nick: nil) }

    before do
      OmniAuth.config.add_mock(:github, { info: { nickname: 'xyz' }})
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
    end

    context 'user has signed up' do
      before { sign_in user }

      it 'updates github nickname' do
        expect { callback }.to change { user.reload.gh_nick }.from(nil).to('xyz')
      end

      it 'redirects to root path' do
        callback
        expect(response).to redirect_to root_path
      end
    end

    context 'user has not signed up' do
      it 'not updates github nickname' do
        expect { callback }.to_not change { user.gh_nick }
      end
    end
  end
end
