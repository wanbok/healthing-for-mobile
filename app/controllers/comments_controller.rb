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
      format.json { render json: { comments: @comments } }
    end
  end

  def show
    @commentable = find_commentable
    redirect_to @commentable ? @commentable : products_path
  end

  # POST /comments
  # POST /comments.json
  def create
    @commentable = find_commentable
    @comment = nil
    unless @commentable.blank?
      @comment = @commentable.comments.build(params['comment'])
      @comment.user_id = User.find_or_create_by_udid(params['udid'])
    end

    respond_to do |format|
      if @comment.blank?
        format.html {
          flash[:notice] = 'Comment can\'t be created without commentable(like parents).'
          redirect_to id: nil
        }
        format.json { render json: {errors: 'Comment can\'t be created without commentable(like parents).'}, status: :unprocessable_entity }
      elsif @comment.save
        format.html {
          flash[:notice] = 'Comment was successfully created.'
          redirect_to id: nil
        }
        format.json { render json: @comment, status: :created, location: @comment }
      else
        format.html { 
          flash[:notice] = 'Comment was failed to create.'
          redirect_to id: nil
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
