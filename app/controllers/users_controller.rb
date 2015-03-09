class UsersController < ApplicationController
  before_filter :require_logged_in_user_or_400,
    :only => [:ban, :unban]

  def show
    @showing_user = User.where(:username => params[:username]).first!
    @title = "User #{@showing_user.username}"
  end

  def tree
    @title = "Users"

    if params[:by].to_s == "karma"
      @users = User.order("karma DESC, id ASC").to_a
      @user_count = @users.length
      @title << " By Karma"
      render :action => "list"
    elsif params[:moderators]
      @users = User.where("is_admin = 1 OR is_moderator = 1").
        order("id ASC").to_a
      @user_count = @users.length
      @title = "Moderators and Administrators"
      render :action => "list"
    else
      users = User.order("id DESC").to_a
      @user_count = users.length
      @users_by_parent = users.group_by(&:invited_by_user_id)
      @newest = User.order("id DESC").limit(10)
    end
  end

  def invite
    @title = "Pass Along an Invitation"
  end

  def ban
    @showing_user = User.where(:username => params[:username]).first!
    if @showing_user.is_banned?
      return render :text => "user already banned", :status => 400
    elsif !@showing_user.is_bannable_by_user?(@user)
      return render :text => "insufficient authority to ban user",
        :status => 403
    end

    @showing_user.ban_by_user_for_reason!(@user, params[:banned_reason])
    redirect_to @showing_user
  end

  def unban
    @showing_user = User.where(:username => params[:username]).first!
    if !(@showing_user.is_banned?)
      return render :text => "user isn't banned", :status => 400
    elsif !@showing_user.is_bannable_by_user?(@user)
      return render :text => "insufficient authority to unban user",
        :status => 403
    end

    @showing_user.unban!
    head :ok
  end
end
