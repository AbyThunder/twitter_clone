RSpec.describe 'Following API', type: :request do
  describe 'show' do
    subject(:api_response) do
      get "/api/users/#{user.id}/followings"
      response
    end
    let(:user) { User.create(name: "Makar", handle: "MK1234234", bio: "cool", email: "makar@toptal.com", password: "123", password_confirmation: "123") }
    
    specify { expect(api_response).to have_http_status(200) }
    specify { expect(JSON.parse(api_response.body).size).to eq(0) }

    context 'when have followers' do
      let(:follower) { User.create(name: "AB", handle: "MK1234234", bio: "cool", email: "makar@toptal.com", password: "123", password_confirmation: "123") }
      let!(:following) { Following.create(user: user, follower: follower) }
      #let!(:tweet) { Tweet.create(content: "Hey", user: user) }

      specify do
        puts user.errors.full_messages
        expect(JSON.parse(api_response.body)).to match([
          hash_including({
            "follower_id" => follower.id,
            "id" => following.id,
            "user_id" => user.id,
            "user" => hash_including("id" => user.id)
          })
        ])
      end
    end
  end

  xdescribe 'create' do
    subject(:api_response) do 
      post "/api/followings", params: params
      response
    end

    let(:params) do
      {
        following: {
          follower_id: follower_id,
          user_id: user.id
        }
      }
    end

    let(:user) { User.create(name: "Makar", handle: "MK1231234", bio: "cool", email: "makar@toptal.com", password: "123", password_confirmation: "123") }

    specify { expect(api_response).to have_http_status(201) }
    specify do
      expect(JSON.parse(api_response.body)).to match(hash_including(
        "content" => "Test",
        "user" => hash_including(
          "id" => user.id,
          "name" => "Makar"
        )
      ))
    end 

    specify { expect { api_response }.to change(Tweet, :count).by(1) }

    context 'with wrong data' do
      context 'without a user' do
        let(:params) do
          {
            tweet: {
              content: "Test"
            }
          }
        end

        specify { expect(api_response).to have_http_status(422) }
        specify { expect { api_response }.not_to change(Tweet, :count) }
        specify { expect(JSON.parse(api_response.body)).to contain_exactly("User must exist") }
      end
    end
  end
end
