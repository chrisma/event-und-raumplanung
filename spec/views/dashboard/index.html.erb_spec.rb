require 'rails_helper'

RSpec.describe "dashboard/index", :type => :view do
	let(:user) { create :user }
	before(:each) do
		login_as user, scope: :user
		visit '/'
	end

	describe 'My Tasks partial' do
		let(:other_user) { create :user }
		let(:event) { create :event }
		let(:past_event) { create :event, name: 'Past Event', starts_at: Date.today - 2, ends_at: Date.today - 2 }
		let(:task) { create :assigned_task, event_id: event.id, user_id: user.id }
		let(:past_task) { create :assigned_task, name: "Past Task", event_id: past_event.id, user_id: user.id }
		let(:other_task) { create :assigned_task, name: "Other Task", event_id: event.id, user_id: other_user.id }

		it 'should render partial' do
			page.should have_content 'My Tasks'
		end

		it 'should only show current events' do
			page.should have_content event.name
			page.should_not have_content past_event.name
		end

		it 'should only show tasks for current events' do
			page.should have_content task.name
			page.should_not have_content past_task.name
		end

		it 'should not show tasks for other users' do
			page.should_not have_content other_task.name	
		end
	end
end