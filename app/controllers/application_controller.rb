class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :installed?
  before_filter :userDecoratorToView

  def list_users seed_list = nil
    seed_list = User.select('*') unless seed_list.present?
    list_models seed_list, %w(first_name last_name email)
  end

  def list_models seed_list, filter_fields = [], order = 'created_at ASC'
    models = seed_list.order order
    # Get and apply our filter
    #if filter_fields.present?
    #  models = models.where build_filter(@filter, filter_fields)
    #end
    models = paginate_models models
  end

  private

  def paginate_models models
    # Get our limit
    @limit = params[:limit].to_i || 12
    @limit = @limit.clamp 12..120
    # Get total count for pagination and our page
    page = (params[:page].to_i - 1) || 1
    @pagination_number_of_pages = (models.count / @limit) + 1
    @pagination_current_page = (page + 1) > 0 ? (page + 1) : 1
    #set the limit
    models = models.limit @limit
    # Set our offset
    models = models.offset(@limit.to_i * page.to_i) if page > 0
    models
  end

  # build the filter for the .where clause in the list_models method
  def build_filter filter, fields
    where = [fields.map { |f| "#{f} like ?" }.join(" || ")]
    fields.count.times { |n| where << "%#{filter}%" }
    where
  end

  #are we installing?  If so redirect to install controller
  def installed?
    if Setting.installing?.present?
      redirect_to install_index_path
    end
  end

  def userDecoratorToView
    @user = UserDecorator.decorate(current_user)
  end
end
