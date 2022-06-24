RSpec.describe 'Report Geneator' do
  require 'sidekiq/testing' # REVIEW: this should rather be in spec/rails_helper.rb
  Sidekiq::Testing.fake! # this as well

  
  before do
    Timecop.freeze('25/06/2022')
    user = User.create(name: "AB", handle: "ab21212", password: "123") 
    tweet = Tweet.create(content: "blabla", user: user)
    Like.create(tweet: tweet, user: user) # Instead of timecop, you can add (created_at: Time.new(2022, 06, 25, 15, 0, 0))
    FindLikesJob.perform_now(user.id, '24/06/2022', '26/06/2022') 
  end

  after { Timecop.return }

  it do
    # expect('./report.csv').not_to be_nil # REVIEW: this will never fail since './report.csv' is a string that is never nil :D 
    expect(File.read(Rails.root.join("report.csv"))).to eq(<<~CSV)
      24/06/2022,0
      25/06/2022,1
      26/06/2022,0
    CSV
  end
end
