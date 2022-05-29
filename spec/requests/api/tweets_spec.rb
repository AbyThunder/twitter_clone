RSpec.describe 'Tweets API', type: :request do
  describe 'index' do
    subject(:api_response) do
      get "/api/tweets"
      response
    end

    specify { expect(api_response).to have_http_status(200) }
    specify { expect(JSON.parse(api_response.body).size).to eq(0) }

    context 'when have tweets' do
      let(:user) { User.create(name: "Makar", handle: "MK1234234", bio: "cool", email: "makar@toptal.com", password: "123", password_confirmation: "123") }
      let!(:tweet) { Tweet.create(content: "Hey", user: user) }

      specify do
        puts user.errors.full_messages
        expect(JSON.parse(api_response.body)).to match([
          hash_including({
            "content" => "Hey",
            "user_id" => user.id
          })
        ])
      end
    end
  end

  describe 'create' do
    subject(:api_response) do 
      post "/api/tweets", params: params
      response
    end

    let(:params) do
      {
        tweet: {
          content: "Test",
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
  
  describe 'update'do
    subject(:api_response) do
      patch "/api/tweets/#{tweet.id}", params: params
      response
    end
    
    let(:user) { User.create(name: "Makar", handle: "MK1231234", bio: "cool", email: "makar@toptal.com", password: "123", password_confirmation: "123") }
    let(:tweet) { Tweet.create(content: "Test", user_id: user.id) }
    let(:params) do
      {
        tweet: {
          content: "NEWTEST"
        }
      }
    end

    specify { expect(api_response).to have_http_status(200) }
    specify do
      expect(JSON.parse(api_response.body)).to match(hash_including(
        "content" => "NEWTEST",
        "user" => hash_including(
          "id" => user.id,
          "name" => "Makar"
        )
      ))
    end 

    context 'with wrong data' do
      context 'without content' do
        let(:params) do
          {
            tweet: {
              content: ""
            }
          }
        end

        specify { expect(api_response).to have_http_status(422) }
        specify { expect(JSON.parse(api_response.body)).to contain_exactly("Content can't be blank") }
      end
    end
  end

  
end
