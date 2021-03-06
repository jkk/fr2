# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://www.federalregister.gov"

SitemapGenerator::Sitemap.add_links do |sitemap|
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: sitemap.add path, options
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly', 
  #           :lastmod => Time.now, :host => default_host
  
  # SECTIONS
  Section.find_each do |section|
    sitemap.add section_path(section)
    sitemap.add about_section_path(section)
  end
  
  # ENTRIES
  Entry.scoped(:joins => :issue, :conditions => "issues.completed_at IS NOT NULL").find_each do |entry|
    sitemap.add entry_path(entry)
  end
  
  Issue.completed.find_each do |issue|
    sitemap.add entries_by_date_path(issue.publication_date)
  end
  
  sitemap.add entries_current_issue_path
  
  # TOPICS
  sitemap.add topics_path
  Topic.find_each do |topic|
    sitemap.add topic_path(topic)
  end
  
  # AGENCIES
  sitemap.add agencies_path
  Agency.find_each do |agency|
    sitemap.add agency_path(agency)
  end
  
  # REGULATIONS
    RegulatoryPlan.find_each do |regulatory_plan|
    sitemap.add regulatory_plan_path(regulatory_plan)
  end
end
