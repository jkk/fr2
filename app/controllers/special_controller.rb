class SpecialController < ApplicationController
  def home
    cache_for 1.day
    @sections = Section.all
    @current_issue = Issue.current
    @approved_issue = Issue.approved
  end
  
  def agency_highlight
    cache_for 10.minutes
    @agency_highlight = AgencyHighlight.random_choice
    if @agency_highlight.present?
      render :layout => false
    else
      render :nothing => true
    end
  end
  
  def popular_entries
    cache_for 1.hour
    @entries = Entry.popular.limit(5)
    
    render :template => "special/popular", :layout => false
  end
  
  def most_emailed_entries
    cache_for 1.hour
    @entries = Entry.most_emailed.limit(5)
    
    render :template => "special/most_emailed", :layout => false
  end
  
  def status
    current_time_on_database = Entry.connection.select_values("SELECT NOW()").first
    render :text => "Current time is: #{current_time_on_database}"
  end
  
  def layout_head_content
    @page_to_track = params[:page_to_track]
    cache_for 1.day
    render :layout => false
  end
  
  def layout_header
    cache_for 1.day
    ab_group = cookies[:ab_group] || 2
    render :action => "layout_header_#{ab_group}", :layout => false
  end
  
  def layout_footer
    cache_for 1.day
    render :layout => false
  end
  
  def robots_dot_txt
    cache_for 1.day
    render :layout => false
  end
end
