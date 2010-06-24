class TopicsController < ApplicationController
  def index
    cache_for 1.day
    redirect_to topics_by_letter_url('a')
  end
  
  def show
    cache_for 1.day
    @topic = Topic.find_by_slug!(params[:id])

    respond_to do |wants|
      wants.html do
        @most_cited_entries = @topic.entries.most_cited(50)
        @entries = @topic.entries.most_recent(50)
        @entry_types = Entry.all(
          :select => 'granule_class, count(*) AS count',
          :joins => :topic_assignments,
          :conditions => {:topic_assignments => {:topic_id => @topic.id}},
          :group => 'granule_class',
          :order => 'count DESC'
        )
        
      end
      wants.rss do
        @feed_name = "Federal Register: #{@topic.name}"
        @feed_description = "Recent Federal Register entries about #{@topic.name}."
        @entries = @topic.entries.most_recent(20)
        render :template => 'entries/index.rss.builder'
      end
    end
  end
  
  def significant_entries
    cache_for 1.day
    @topic = Topic.find_by_slug!(params[:id])
    
    respond_to do |wants|
      wants.rss do
        @feed_name = "Federal Register: Significant articles from the '#{@topic.name}' topic"
        @feed_description = "Significant Federal Register articles from the '#{@topic.name}' topic."
        @entries = @topic.entries.significant.most_recent(20).preload(:topics, :agencies)
        render :template => 'entries/index.rss.builder'
      end
    end
  end
  
  def by_letter
    cache_for 1.day
    @letter = params[:letter]
    @letters = ('a' .. 'z')
    
    @popular_topics = Topic.find(:all, :order => 'entries_count DESC', :limit => 100).sort_by(&:name)
    
    @topics = Topic.all(:conditions => ["entries_count > 0 AND slug LIKE ?", "#{@letter}%"], :order => "topics.name")
  end
end