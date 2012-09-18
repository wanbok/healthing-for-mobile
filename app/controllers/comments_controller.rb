class CommentsController < ApplicationController
  before_filter :authorize, :only => [:destroy]
  # GET /comments
  # GET /comments.json
  def index
    @commentable = find_commentable
    @comments = []
    if @commentable
      @comments = @commentable.comments
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: { comments: @comments == [] ? nil : @comments } }
    end
  end

  # POST /comments
  # POST /comments.json
  def create
    @commentable = find_commentable
    @comment = @commentable.comments.build(params['comment'])
    @comment.user_id = User.find_or_create_by_udid(params['udid'])

    respond_to do |format|
      if @comment.save
        format.html {
          flash[:notice] = 'Comment was successfully created.'
          redirect_to @commentable
        }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { 
          flash[:notice] = 'Comment was failed to create.'
          redirect_to @commentable
        }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment = Comment.find(params[:id])

    @commentable = @comment.commentable

    @comment.destroy

    respond_to do |format|
      format.html {
        flash[:notice] = 'Comment was successfully deleted.'
        redirect_to @commentable
      }
      format.json { head :no_content }
    end
  end

  private

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
