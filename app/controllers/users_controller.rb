class UsersController < ApplicationController
  
  @@searched_users = nil

  def index
    if @@searched_users.nil?
      @users = User.all
    else
      @users = @@searched_users
      @@searched_users = nil
    end
  end

 

  def search
    web = params[:web].to_i
    crypto = params[:crypto].to_i
    reversing = params[:reversing].to_i
    pwn = params[:pwn].to_i
    misc = params[:misc].to_i
    begin
      @users = User.where("web > ?", web - 1).where("crypto > ?", crypto - 1).where("reversing > ?", reversing - 1).where("pwn > ?", pwn - 1).where("misc > ?", misc - 1)
      @@searched_users = @users
      redirect_to users_url
    rescue
      flash.now[:danger] = "検索に失敗しました"
      render 'index'
    end
  end

  def new
    @user = User.new()
  end

  def edit
  end
  
  def show
    @user = User.find(params[:id])
  end
  

  def create
    user = User.new(user_params)
    if user.save
      login user
      redirect_to root_url, success: "CtFinderへようこそ！"
    else
      flash.now[:danger] = "ユーザーの保存に失敗しました"
      render 'new' 
    end
  end

  def destroy
    user = current_user
    unless user.nil?
      user.destroy
      redirect_to root_url, success: "さようなら！！"
    else
      flash[:danger] = "ログインしていません"
      redirect_to root_url
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :web, :crypto, :reversing, :pwn, :misc, :self_introduction)
    end

end
