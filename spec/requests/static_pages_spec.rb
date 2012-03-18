require 'spec_helper'

describe "StaticPages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading) { 'Special' }
    let(:page_title) { 'Home' }

    it_should_behave_like "all static pages"

    describe "for signed-in users" do
      let(:user) { Factory(:user) }
      before do
        Factory(:micropost, user: user, content: "Lorem ipsum")
        Factory(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end

      it "should display the microposts count" do
        page.should have_selector('span', content: "#{plural(user.microposts.count, "micropost")}")
      end

      describe "follower/following counts" do
        let(:other_user) { Factory(:user) }
        before { user.follow!(other_user) }

        it { should have_selector('a', href: following_user_path(user), content: "0 following") }
        it { should have_selector('a', href: followers_user_path(user), content: "1 follower") }
      end
    end
  end

  describe "Help Page" do
    before { visit help_path }
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading) { 'About Us' }
    let(:page_title) { 'About' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    page.should have_selector 'title', text: full_title('About')
    click_link "Help"
    page.should have_selector 'title', text: full_title('Help')
    click_link "Contact"
    page.should have_selector 'title', text: full_title('Contact')
    click_link "Home"
    page.should have_selector 'title', text: full_title('Home')
    click_link "Sign up now!"
    page.should have_selector 'title', text: full_title('Sign up')
  end

end
