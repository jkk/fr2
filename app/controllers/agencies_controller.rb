class AgenciesController < ApplicationController
  def index
    cache_for 1.day
    @agencies  = Agency.all(:order => 'name ASC', :include => :children)
  end
  
  def search
    agencies = Agency.with_entries.named_approximately(params[:term]).limit(10)
    render :json => agencies.map{|a| {:id => a.id, :name => a.name_and_short_name} }
  end
  
  def show
    cache_for 1.day
    @agency = Agency.find_by_slug!(params[:id])
    respond_to do |wants|
      wants.html do
        @entries = EntrySearch.new(:conditions => {:agency_ids => [@agency.id]}, :order => "newest", :per_page => 40).results
        @significant_entries = EntrySearch.new(:conditions => {:agency_ids => [@agency.id], :significant => '1', :publication_date => {:gte => 3.months.ago.to_date.to_s}}, :order => "newest", :per_page => 40).results
        @comments_closing = @agency.entries.comments_closing
        @comments_opening = @agency.entries.comments_opening
      end
      
      wants.rss do
        @entries = EntrySearch.new(:conditions => {:agency_ids => [@agency.id]}, :order => "newest", :per_page => 20).results
        @feed_name = "Federal Register: #{@agency.name}"
        @feed_description = "Recent Federal Register articles from #{@agency.name}."
        render :template => 'entries/index.rss.builder'
      end
    end
    
  end
  
  def significant_entries
    cache_for 1.day
    @agency = Agency.find_by_slug!(params[:id])
    
    respond_to do |wants|
      wants.rss do
        @entries = @agency.entries.significant.most_recent(20)
        @feed_name = "Federal Register: #{@agency.name} Significant Articles"
        @feed_description = "Recent Federal Register articles from #{@agency.name} on significant regulations."
        render :template => 'entries/index.rss.builder'
      end
    end
  end
end