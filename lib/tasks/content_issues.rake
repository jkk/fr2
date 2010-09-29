namespace :content do
  namespace :issues do
    task :mark_complete => :environment do
      date = ENV['DATE'] || Time.current.to_date
      
      issue = Issue.find_by_publication_date(date) || Issue.new(:publication_date => date)
      issue.complete!
    end
  end
end