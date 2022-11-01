require 'rails_helper'
require "./spec/support/login_user.rb"

RSpec.describe User, :type => :request do
        context "when user is not logged in" do
          it 'render a page to sign in' do
          get "/events"
          expect(response).to redirect_to(new_user_session_url)
          expect(response).to redirect_to('/users/sign_in')
          end
        end
        
        context "when user is logged in" do
          context "when the normal user logged in" do
            subject { create(:event) }
            include_context :login_user
                describe "GET /index" do
                  it "returns http success" do
                      get "/events"
                      expect(response).to have_http_status(:success)
                  end
                end

                describe 'GET /show' do
                  it 'renders a successful response' do
                  get event_url(subject)
                  expect(response).to have_http_status(200)
                  end
                end

                describe 'GET /new' do
                  it 'raises an authorization error' do
                  expect { get '/events/new' }.to raise_error(CanCan::AccessDenied)
                  end
                end

                describe 'POST /create' do
                  subject { create(:admin_user) }
                  context 'with valid parameters' do
                    it 'raises error while creating a new Event' do
                      expect do
                      post events_url, params: { event: { admin_user_id: subject.id,event_name: "XYZ",description: "Anythinggggg",event_date: DateTime.now,price: 100.00 } }
                      end.to raise_error(CanCan::AccessDenied)
                    end
                  end
                end

            end
        end
end