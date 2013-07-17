require 'spec_helper'

describe "StaticPages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: page_title) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    let(:page_title) { t('static_pages.home.title') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's name and nick" do
        page.should have_selector 'h1', text: user.name
        page.should have_selector 'h1 .nick', text: user.nick
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
          page.should have_selector("li##{item.id} .nick", text: item.user.nick)
        end
      end

      it "should display the microposts count" do
        page.should have_selector('span', content: "#{plural(user.microposts.count, "micropost")}")
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before { user.follow!(other_user) }

        it { should have_selector('a', href: following_user_path(user), content: "0 following") }
        it { should have_selector('a', href: followers_user_path(user), content: "1 follower") }
      end
    end
  end

  describe "Help Page" do
    before { visit help_path }
    let(:page_title) { t('static_pages.help.title') }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:page_title) { t('static_pages.about.title') }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:page_title) { t('static_pages.contact.title') }

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link t('static_pages.about.title')
    page.should have_selector 'title', text: full_title(t('static_pages.about.title'))
    click_link t('static_pages.help.title')
    page.should have_selector 'title', text: full_title(t('static_pages.help.title'))
    click_link t('static_pages.contact.title')
    page.should have_selector 'title', text: full_title(t('static_pages.contact.title'))
    click_link t('static_pages.home.title')
    page.should have_selector 'title', text: full_title(t('static_pages.home.title'))
    click_link t('signup_now')
    page.should have_selector 'title', text: full_title(t('users.new.title'))
  end

end
