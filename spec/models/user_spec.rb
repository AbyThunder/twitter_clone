# RSpec.describe User do
#   describe 'validations' do
#     describe 'name' do
#       subject(:user) {User.new(name: 'Makar', handle: 'MKKKKKK')}
      
#       specify { expect(user).to be_valid}

#       context 'when name is empty' do
#         subject(:user) {User.new(name: '', handle: 'MKKKKKKK')}
      
#         specify { expect(user).to be_invalid}
#       end
#     end
#   end
# end

# RSpec.describe User do
#   describe 'validations' do
#     # describe 'name' do
#     #   subject(:user) { User.new(name: 'Makar', handle: "earendil") }

#     #   specify { expect(user).to be_valid } # user.valid? should return true
#     #   # specify { expect(user).to be_crazy }

#     #   context 'when name is empty' do
#     #     subject(:user) { User.new(handle: "earendil") }

#     #     # specify { expect(user).not_to be_valid }
#     #     specify { expect(user).to be_invalid }
#     #     specify do
#     #       user.valid?
#     #       expect(user.errors.full_messages).to include("Name can't be blank")
#     #     end
#     #   end
#     # end

#     specify { is_expected.to validate_presence_of(:name) }
#     specify { is_expected.to validate_presence_of(:handle) }
#     specify { is_expected.to validate_length_of(:handle).is_at_least(6).is_at_most(256) }

#     describe 'handle format' do
#       subject(:user) { User.new(name: "Makar", handle: "two wo") }

#       specify { is_expected.to be_invalid }
#       specify do
#         user.valid?
#         expect(user.errors.full_messages).to eq(["Handle is invalid"])
#       end

#       context 'when handle is valid' do
#         subject(:user) { User.new(name: 'Makar', handle: "Earendil_-9225") }

#         specify { is_expected.to be_valid }
#       end
#     end
#   end

#   # context 'associations' do
#   #   specify { expect(user).to have_many(:tweets) }
#   # end
# end

RSpec.describe User do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    specify { should validate_presence_of(:handle) }
    specify { should validate_length_of(:handle).is_at_least(2).is_at_most(256)}

    
    describe 'handle format' do
      let(:user) { User.new(name: "AB", handle: "lol lol", password: "ab21") }

      it { should be_invalid }

      it do
        user.valid?
        expect(user.errors.full_messages).to eq(["Handle is invalid"])
      end

      context 'when handle is valid' do
        subject(:user) { User.new(name: "AB", handle: "lololll", password: "ab21") }
        it { should be_valid }
      end
    end
  end
  describe 'associations' do
    it { should have_many(:tweets).class_name('Tweet') }
  end


end