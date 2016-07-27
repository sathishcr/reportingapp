class RelationshipsController < ApplicationController
  before_filter :signed_in_user
  before_filter :before_creating_relationships, only: :create
  before_filter :before_destroying_relationships, only: :destroy

  def create
    current_user.follow!(@user)
    redirect_to @user
  end

  def destroy
    current_user.unfollow!(@user)
    redirect_to @user
  end

  private
    def before_creating_relationships
      @user = User.find(params[:relationship][:followed_id])
    end
    def before_destroying_relationships
      @user = Relationship.find(params[:id]).followed
    end
end
