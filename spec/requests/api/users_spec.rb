RSpec.describe 'Users API', type: :request do
  context 'User is not authorized' do
    context '#index' do
      subject do
        get '/api/users#index'
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end

    context '#show' do
      let(:user) do
        User.create(name: "Makar", handle: "MK1234234", bio: "cool", email: "makar@toptal.com", password: "123", password_confirmation: "123")
      end
      subject do
        get "/api/users/#{user.id}"
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end

    context '#update' do
      let(:user) do
        User.create(name: "Makar", handle: "MK1234234", bio: "cool", email: "makar@toptal.com", password: "123", password_confirmation: "123")
      end
      subject do
        get "/api/users/#{user.id}", params: { user: { name: 'AB' } }
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end

    context '#destroy' do
      let(:user) do
        User.create(name: "Makar", handle: "MK1234234", bio: "cool", email: "makar@toptal.com", password: "123", password_confirmation: "123")
      end
      subject do
        delete "/api/users/#{user.id}"
        JSON.parse(response.body)
      end
      specify { expect(subject).to include('errors' => 'Nil JSON web token') }
    end
  end


  context 'User is authorized' do
    let!(:user) { User.create(name: "Makar", handle: "MK1234234", bio: "cool", email: "makar@toptal.com", password: "123", password_confirmation: "123") }
    let!(:token) { JsonWebToken.encode(user_id: user.id )}
    describe 'index' do
      subject(:api_response) do
        get "/api/users", headers: { "Authorization" => "#{token}" }
        response
      end

      specify { expect(api_response).to have_http_status(200) }
      specify { expect(JSON.parse(api_response.body).size).to eq(1) }

      context 'when have Users' do
        let(:user) { User.create(name: "Makar", handle: "MK1234234", bio: "cool", email: "makar@toptal.com", password: "123", password_confirmation: "123") }

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
            name: "Makar", handle: "MK1234234", bio: "cool", email: "makar@toptal.com", password: "123", password_confirmation: "123"
          }
        }
      end

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
                handle: "AB123456",
                password: "123"
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
        patch "/api/users/#{user.id}", params: params, headers: { "Authorization" => "#{token}" }
        response
      end
      let(:user) { User.create(name: "NEWTEST", handle: "MK1231234", bio: "cool", email: "makar@toptal.com", password: "123", password_confirmation: "123") }
      let(:params) do
        {
          user: {
            name: "Makar", handle: "MK1234234", bio: "cool", email: "makar@toptal.com", password: "123", password_confirmation: "123"
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
        delete "/api/users/#{user.id}", headers: { "Authorization" => "#{token}" }
        response
      end
      let!(:user) { User.create(name: "Makar", handle: "MK1231234", bio: "cool", email: "makar@toptal.com", password: "123", password_confirmation: "123") }

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
end
