require 'spec_helper'

feature 'Pagination button' do
  1000.times { |i| let!("user_#{i}".to_sym) { create(:user_with_karma, :total => rand(500), :points => 1) } }
  it "should appear on any page with a valid page URL" do
    visit "/?page=3"
    page.find("div.pagination")
  end

  it "should go to page indicated by button" do
    visit "/?page=3"
    click_link "4"
    # expect(page.current_path).to eq users_path(4)
    page.find("li.active a[href='/users?page=4']")
  end
end