require 'spec_helper'

describe User do
  it { should have_many(:karma_points) }

  describe '#valid?' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    it { should validate_presence_of(:username) }
    it { should ensure_length_of(:username).is_at_least(2).is_at_most(32) }

    it { should validate_presence_of(:email) }

    context 'when a user already exists' do
      before { create(:user) }

      it { should validate_uniqueness_of(:username).case_insensitive }
      it { should validate_uniqueness_of(:email).case_insensitive }
    end
  end

  describe '.by_karma' do
    it 'returns users in order of highest-to-lowest karma' do
      user_med   = create(:user_with_karma, :total => 500, :points => 2)
      user_low   = create(:user_with_karma, :total => 200, :points => 2)
      user_high  = create(:user_with_karma, :total => 800, :points => 2)

      User.by_karma.should eq [user_high, user_med, user_low]
    end
  end

  describe '#total_karma' do
    let(:user) { create(:user_with_karma, :total => 500, :points => 2) }

    it 'returns the total karma for the user' do
      user.total_karma.should eq 500
    end
  end

  describe '#full_name' do
    let(:user) { build(:user) }

    it 'returns both the first and last names in a single string' do
      user.first_name = 'John'
      user.last_name  = 'Doe'
      user.create_full_name

      user.full_name.should eq 'John Doe'
    end
  end

  describe '#page' do
    1000.times { |i| let!("user_#{i}".to_sym) { create(:user_with_karma, :total => rand(500), :points => 1) } }

    it 'returns 100 users sorted by karma for the given page number' do
      expect(User.page(1).first).to eq User.by_karma[0...100].first
      expect(User.page(1).last).to eq User.by_karma[0...100].last
    end

    it "returns the first page if page number isn't specified" do
      expect(User.page).to eq User.by_karma[0...100]
    end

    it "returns the last page if given a page number greater than the total page number" do
      expect(User.page(1000000)).to eq User.by_karma[900..-1]
    end
  end
end
