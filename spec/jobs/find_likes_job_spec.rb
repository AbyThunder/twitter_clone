RSpec.describe 'Report Geneator' do
  require 'sidekiq/testing'
  Sidekiq::Testing.fake!

  let(:report) { FindLikesJob.perform_now(1, '24/03/2022', '24/06/2022') }
  
  it do
    expect('./report.csv').not_to be_nil
  end
end