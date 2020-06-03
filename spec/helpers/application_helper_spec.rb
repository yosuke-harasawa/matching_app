require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  
  describe "#full_title" do
    context "page_title is empty" do
      it "removes symbole" do
        expect(helper.full_title).to eq('meet')
      end
    end
    
    context "page_title is not empty" do
      it "returns title and application name where contains symbole" do
        expect(helper.full_title('about')).to eq('about | meet')
      end
    end  
  end  
end
