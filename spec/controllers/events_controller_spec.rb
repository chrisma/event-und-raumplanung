require 'rails_helper'
require "cancan/matchers"

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe EventsController, :type => :controller do
  include Devise::TestHelpers

  let(:valid_session) {
  }
  let(:task) { create :task }
  let(:user) { create :user }

  let(:valid_attributes) {
    {name:'Michas GB',
    description:'Coole Sache',
    participant_count: 2000,
    starts_at_date:'2020-08-23',
    ends_at_date:'2020-08-23',
    starts_at_time:'17:00',
    ends_at_time:'23:59',
    is_private: true,
    user_id: user.id
    }
  }
 
 let(:valid_attributes_for_request) {
    {name:'Michas GB',
    description:'Coole Sache',
    participant_count: 2000,
    starts_at_date:'2020-08-23',
    ends_at_date:'2020-08-23',
    starts_at_time:'17:00',
    ends_at_time:'23:59',
    rooms: ["1", "2"], 
    is_private: true,
    user_id: user.id
    }
  }

  let(:invalid_attributes) {
    {
    name:'Michas GB',
    starts_at_date:'2014-08-23',
    ends_at_date:'2014-08-23',
    starts_at_time:'17:00',
    ends_at_time:'23:59',
    user_id: user.id
	}
  }

  let(:invalid_attributes_for_request) {
    {
    name:'Michas GB',
    starts_at_date:'2014-08-23',
    ends_at_date:'2014-08-23',
    starts_at_time:'17:00',
    ends_at_time:'23:59', 
    rooms:[],
    user_id: user.id
  }
  }

   let(:invalid_participant_count) {
    {name:'Michas GB',
   	participant_count:-100,
   	starts_at_date:'2020-08-23',
    ends_at_date:'2020-08-23',
    user_id: user.id
    }
  }

  let(:invalid_participant_count_for_request) {
    {name:'Michas GB',
    participant_count:-100,
    starts_at_date:'2020-08-23',
    ends_at_date:'2020-08-23',
    rooms: [],
    user_id: user.id
    }
  }



  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end

  describe "GET index" do
    it "assigns all events as @events" do
      event = Event.create! valid_attributes
      get :index, {}, valid_session
      expect(assigns(:events)).to eq([event])
    end
  end

  describe "GET show" do
    it "assigns the requested event as @event" do
      event = Event.create! valid_attributes
      get :show, {:id => event.to_param}, valid_session
      expect(assigns(:event)).to eq(event)
    end
  end

  describe "GET new" do
    it "assigns a new event as @event" do
      get :new, {}, valid_session
      expect(assigns(:event)).to be_a_new(Event)
    end
  end

  describe "GET new_event_template" do
    it "assigns a new event_template as @event_template" do
      event = Event.create! valid_attributes
      get :new_event_template, {:id => event.to_param}, valid_session
      expect(assigns(:event_template).name).to eq event.name
      expect(assigns(:event_template).description).to eq event.description
      expect(assigns(:event_template).user_id).to eq user.id
      expect(assigns(:event_template).room_id).to eq event.room_id
      expect(response).to render_template("event_templates/new")
    end
  end

  describe "GET edit" do
    it "assigns the requested event as @event" do
      event = Event.create! valid_attributes
      get :edit, {:id => event.to_param}, valid_session
      expect(assigns(:event)).to eq(event)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Event" do
        expect {
          post :create, {:event => valid_attributes_for_request}, valid_session
        }.to change(Event, :count).by(1)
      end

      it "assigns a newly created event as @event" do
        post :create, {:event => valid_attributes_for_request}, valid_session
        expect(assigns(:event)).to be_a(Event)
        expect(assigns(:event)).to be_persisted
      end

      it "redirects to the created event" do
        post :create, {:event => valid_attributes_for_request}, valid_session
        expect(response).to redirect_to(Event.last)
      end
    end

    describe "with invalid dates" do
      it "assigns a newly created but unsaved event as @event" do
        post :create, {:event => invalid_attributes_for_request}, valid_session
        expect(assigns(:event)).to be_a_new(Event)
      end

      it "re-renders the 'new' template" do
        post :create, {:event => invalid_attributes_for_request}, valid_session
        expect(response).to render_template("new")
      end
    end
	describe "with invalid participant count" do
      it "assigns a newly created but unsaved event as @event" do
        post :create, {:event => invalid_participant_count_for_request}, valid_session
        expect(assigns(:event)).to be_a_new(Event)
      end

      it "re-renders the 'new' template" do
        post :create, {:event => invalid_participant_count_for_request}, valid_session
        expect(response).to render_template("new")
      end
    end

   end

  describe "PUT update" do
    describe "with valid params" do
      let(:new_attributes) {
        {name:'Michas GB 2',
        description:'Keine coole Sache',
        participant_count: 1,
        rooms: []
        }
      }

      it "updates the requested event" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => new_attributes}, valid_session
        event.reload
        #expect(event.name).to eq 'Michas GB 2'
        #expect(event.description).to eq 'Keine coole Sache'
        #expect(event.participant_count).to be 1

      end

      it "assigns the requested event as @event" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => valid_attributes_for_request}, valid_session
        expect(assigns(:event)).to eq(event)
      end

      it "redirects to the event" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => valid_attributes_for_request}, valid_session
        expect(response).to redirect_to(event)
      end
    end

    describe "with invalid params" do
      it "assigns the event as @event" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => invalid_attributes_for_request}, valid_session
        expect(assigns(:event)).to eq(event)
      end

      it "re-renders the 'edit' template" do
        event = Event.create! valid_attributes
        put :update, {:id => event.to_param, :event => invalid_attributes_for_request}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested event" do
      event = Event.create! valid_attributes
      expect {
        delete :destroy, {:id => event.to_param}, valid_session
      }.to change(Event, :count).by(-1)
    end

    it "redirects to the events list" do
      event = Event.create! valid_attributes
      delete :destroy, {:id => event.to_param}, valid_session
      expect(response).to redirect_to(events_url)
    end
  end

end
