##
## Copyright [2013-2015] [Megam Systems]
##
## Licensed under the Apache License, Version 2.0 (the "License");
## you may not use this file except in compliance with the License.
## You may obtain a copy of the License at
##
## http://www.apache.org/licenses/LICENSE-2.0
##
## Unless required by applicable law or agreed to in writing, software
## distributed under the License is distributed on an "AS IS" BASIS,
## WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
## See the License for the specific language governing permissions and
## limitations under the License.
##
class PasswordResetsController < ApplicationController
  skip_before_action :require_signin, only: [:edit, :create, :update]


  def create
	   @user = User.new
     user = @user.find_by_email(params[:email])
     if user
          @user.send_password_reset(params[:email])
        end
    else
      logger.debug "Email doesn't match with megam account"
      @error = "not_match"
    end
  end

  def edit
	  user = User.new
    @user = user.find_by_password_reset_token(params[:id], params[:email])
	  @user
  end

  def update
	  user_obj = User.new
    @user = user_obj.find_by_password_reset_token(params[:id], params[:email])
    if @user["password_reset_sent_at"] < 2.hours.ago
      redirect_to signin_path, :alert => "Password reset has expired."
    elsif true
	    update_options = { "password" => user_obj.password_encrypt(params[:password]), "password_confirmation" => user_obj.password_encrypt(params[:password_confirmation]) }
      res_update = user_obj.update_columns(update_options, params[:email])
      redirect_to root_url, :notice => "Password has been reset!"
    else
      render :edit
    end
  end
end
