require 'rails_helper'

  RSpec.describe StaticPagesController, type: :controller do
    
    describe "#home" do
      it "responds successfully" do
        get :home
        expect(response).to be_success
      end  
    end
    
    describe "#about" do
      it "responds successfully" do
        get :about
        expect(response).to be_success
      end
    end  
    
  end