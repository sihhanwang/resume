class GroupsController < ApplicationController
before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
before_action :find_group_and_check_permission, only: [:edit, :update, :destroy]
  def index
    @groups = Group.all
  end



    def show
      @group = Group.find(params[:id])
      @posts = @group.posts.recent.paginate(:page => params[:page], :per_page => 5)
end

    def edit
    end

  def new
    @group = Group.new
  end

  def create
   @group = Group.new(group_params)
    @group.user = current_user
   if @group.save
      current_user.join!(@group)
     redirect_to groups_path
   else
     render :new
   end
 end

   def update
    if @group.update(group_params)
        redirect_to groups_path, notice: "已更新"
      else
        render :edit
      end
    end

    def destroy
      @group.destroy
      flash[:alert] = "刪除成功"
      redirect_to groups_path
    end

    def join
      @group = Group.find(params[:id])

       if !current_user.is_member_of?(@group)
         current_user.join!(@group)
         flash[:notice] = "收藏成功！"
       else
         flash[:warning] = "已收藏！"
       end

       redirect_to group_path(@group)
     end

     def quit
       @group = Group.find(params[:id])

       if current_user.is_member_of?(@group)
         current_user.quit!(@group)
         flash[:alert] = "已取消收藏！"
       else
         flash[:warning] = "沒有收藏過無法取消"
       end

       redirect_to group_path(@group)
     end

 private

 def find_group_and_check_permission
     @group = Group.find(params[:id])

     if current_user != @group.user
       redirect_to root_path, alert: "無此權限"
     end
   end

 def group_params
   params.require(:group).permit(:title, :description)
 end
end
