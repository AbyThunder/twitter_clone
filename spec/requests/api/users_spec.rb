RSpec.describe 'Users API', type: :request do
  describe 'index' do
    subject(:api_response) do
      get "/api/users"
      response
    end

    specify { expect(api_response).to have_http_status(200) }
    specify { expect(JSON.parse(api_response.body).size).to eq(0) }

    context 'when have Users' do
      let(:user) { User.create(name: "Makar", handle: "MK1234234", bio: "cool", email: "makar@toptal.com") }

      specify do
        puts user.errors.full_messages
        expect(JSON.parse(api_response.body)).to match([
          hash_including({
            "name" => "Makar",
            "handle" => "MK1234234",
            "bio" => "cool",
            "email" => "makar@toptal.com",
            "id" => user.id
          })
        ])
      end
    end
  end

  describe 'create' do
    subject(:api_response) do 
      post "/api/users", params: params
      response
    end

    let(:params) do
      {
        user: {
          name: "Makar", handle: "MK1234234", bio: "cool", email: "makar@toptal.com"
        }
      }
    end

    #let(:user) { User.create(name: "Makar", handle: "MK1231234", bio: "cool", email: "makar@toptal.com") }

    specify { expect(api_response).to have_http_status(201) }
    specify do
      expect(JSON.parse(api_response.body)).to match(hash_including(
        "name" => "Makar",
        "handle" => "MK1234234",
        "bio" => "cool",
        "email" => "makar@toptal.com",
        "tweets" => []
      ))
    end 

    specify { expect { api_response }.to change(User, :count).by(1) }

    context 'with wrong data' do
      context 'without a user name' do
        let(:params) do
          {
            user: {
              handle: "AB123456"
            }
          }
        end

        specify { expect(api_response).to have_http_status(422) }
        specify { expect { api_response }.not_to change(User, :count) }
        specify { expect(JSON.parse(api_response.body)).to contain_exactly("Name can't be blank") }
      end
    end
  end
  
  describe 'update' do    
    subject(:api_response) do
      patch "/api/users/#{user.id}", params: params
      response
    end
    let(:user) { User.create(name: "NEWTEST", handle: "MK1231234", bio: "cool", email: "makar@toptal.com") }
    let(:params) do
      {
        user: {
          name: "Makar", handle: "MK1234234", bio: "cool", email: "makar@toptal.com"
        }
      }
    end
   
    specify { expect(api_response).to have_http_status(200) }

    specify do
      expect(JSON.parse(api_response.body)).to match(hash_including(
        "name" => "Makar",
        "handle" => "MK1234234",
        "bio" => "cool",
        "email" => "makar@toptal.com",
        "id" => user.id,
        "tweets" => []
      ))
    end 
  end

  describe 'destroy' do
    subject(:api_response) do 
      delete "/api/users/#{user.id}"
      response
    end
    let!(:user) { User.create(name: "Makar", handle: "MK1231234", bio: "cool", email: "makar@toptal.com") }

    specify { expect(api_response).to have_http_status(200) }

    specify do
      expect(JSON.parse(api_response.body)).to match(hash_including(
        "name" => "Makar",
        "handle" => "MK1231234",
        "bio" => "cool",
        "email" => "makar@toptal.com",
        "id" => user.id,
        "tweets" => []
      ))
    end
    
    specify { expect { api_response }.to change(User, :count).by(-1) }
  end
end
