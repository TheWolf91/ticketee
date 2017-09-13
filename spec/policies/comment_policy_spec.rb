require 'rails_helper'

RSpec.describe CommentPolicy do
  context "permissions" do
    subject { CommentPolicy.new(user, comment) }

    let(:user) { FactoryGirl.create(:user) }
    let(:project) { FactoryGirl.create(:project) }
    let(:ticket) { FactoryGirl.create(:ticket, project: project) }  #"author: User.new" è stato aggiunto perché era un parametro richiesto,
    let(:comment) { FactoryGirl.create(:comment, ticket: ticket) }  # ma Rails 4 avrebbe fatto passare il test anche senza

    context "for anonymous users" do
      let(:user) { nil }
      it { should_not permit_action :create }
    end

    context "for viewers of the project" do
      before { assign_role!(user, :viewer, project) }
      it { should_not permit_action :create }
    end

    context "for editors of the project" do
      before { assign_role!(user, :editor, project) }
      it { should permit_action :create }
    end

    context "for managers of the project" do
      before { assign_role!(user, :manager, project) }
      it { should permit_action :create }
    end

    context "for managers of other projects" do
      before { assign_role!(user, :manager, FactoryGirl.create(:project)) }
      it { should_not permit_action :create }
    end

    context "for administrators" do
      let(:user) { FactoryGirl.create(:user, :admin) }
      it { should permit_action :create }
    end
  end
end