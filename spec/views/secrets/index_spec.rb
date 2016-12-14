require 'rails_helper'

describe 'secrets/index.html.erb' do 
  
  let(:user_secret) { create(:secret) }
  let(:other_secret) { create(:secret) }

  context "signed in user" do

    before do 
      
      def view.signed_in_user?
        true
      end

      @current_user = user_secret.author
      
      def view.current_user
        @current_user
      end
    end

    it "renders secrets' authors" do 
      assign(:secrets, [user_secret, other_secret])
      render
      expect(rendered).to match(user_secret.author.name)
      expect(rendered).to match(other_secret.author.name)
    end

    it "allows editing and destroying of users' secrets" do 
      assign(:secrets, [user_secret])
      render
      expect(rendered).to match("Edit")
      expect(rendered).to match("Destroy")
    end

    it "does not allow editing and destroying of other users' secrets" do 
      assign(:secrets, [other_secret])
      render
      expect(rendered).to_not match("Edit")
      expect(rendered).to_not match("Destroy")
    end
  end

  context "visitor" do 

    before do 
      
      def view.signed_in_user?
        false
      end

      @current_user = user_secret.author
      
      def view.current_user
        nil
      end

      assign(:secrets, [user_secret, other_secret])
      render
    end

    it "renders authors as hidden" do 
      
      expect(rendered).to match /\*\*hidden\*\*/
    end
  end
end