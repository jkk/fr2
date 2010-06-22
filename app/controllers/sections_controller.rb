class SectionsController < ApplicationController
  include Shared::SectionsControllerUtilities
  
  def show
    cache_for 1.day
    
    prepare_for_show(params[:slug], Entry.latest_publication_date)
    @preview = false
    respond_to do |wants|
      wants.html do
        @agency = Agency.with_logo.find(:all,
                              :select => "agencies.*, count(entries.id) AS num_entries_this_month",
                              :joins => {:entries => :sections},
                              :conditions => {
                                :sections => {:id => @section.id},
                                :entries => {:publication_date => (1.month.ago .. Date.today)}
                              },
                              :group => "entries.id",
                              :order => "num_entries_this_month DESC",
                              :limit => 10
        ).sort_by { rand }.first
        render :action => :show
      end
      
      wants.rss do
        @feed_name = "Federal Register: '#{@section.title}' Section"
        @feed_description = "Most Recent Federal Register articles from the '#{@section.title}' Section."
        @entries = @section.entries.published_on(@publication_date).preload(:topics, :agencies)
        render :template => 'entries/index.rss.builder'
      end
      
    end
  end
  
  def about
    cache_for 1.day
    @section = Section.find_by_slug!(params[:slug])
  end
  
  def highlighted
    cache_for 1.day
    @section = Section.find_by_slug!(params[:slug])
    
    respond_to do |wants|
      wants.rss do
        @feed_name = "Federal Register: Featured articles from the '#{@section.title}' Section"
        @feed_description = "Featured Federal Register articles from the '#{@section.title}' Section."
        @entries = @section.highlighted_entries.preload(:topics, :agencies)
        render :template => 'entries/index.rss.builder'
      end
    end
  end
  
  def significant
    cache_for 1.day
    @section = Section.find_by_slug!(params[:slug])
    
    respond_to do |wants|
      wants.rss do
        @feed_name = "Federal Register: Significant articles from the '#{@section.title}' Section"
        @feed_description = "Significant Federal Register articles from the '#{@section.title}' Section."
        @entries = @section.entries.significant.most_recent(20).preload(:topics, :agencies)
        render :template => 'entries/index.rss.builder'
      end
    end
  end
  
  def popular
    cache_for 1.hour
    @section = Section.find_by_slug!(params[:slug])
    @entries = @section.entries.popular(5)
  end
  
end