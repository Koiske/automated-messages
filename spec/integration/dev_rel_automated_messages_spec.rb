require "rails_helper"

RSpec.describe "Dev Rel Automated Messages" do
	let(:dev_rel) { Fabricate(:group, name: "DevRelationsTeam") }
	let(:user) { Fabricate(:user) }

	before do
		5.times do |i|
			dev_rel.add(Fabricate(:user, username: "DevRel" + i.to_s))
		end

		SiteSetting.site_contact_username = "system"
	end

	it "shouldn't override site_contact_username" do
		expect(SiteSetting.site_contact_username).to eq("system")
	end

	it "should send promo messages from dev rel instead of system" do
		captured = [false, false, false, false, false]
		5.times do
			system_message = SystemMessage.new(user).create("welcome_tl1_user")
			system_message.reload
			user = system_message.user
			expect(dev_rel.user_ids).to include(user.id)
			dev_rel.remove user
			captured[user.username[-1].to_i] = true
		end
		expect(captured).not_to include(false)
	end

	it "should send other system messages through system" do
		system_message = SystemMessage.new(user).create("random_system_mesage")
		system_message.reload
		expect(system_message.user.username).to eq("system")
	end
end
