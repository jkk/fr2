namespace :data do
  task :daily => %w(
    data:download:entries
    data:import:entries
    data:download:full_text
    data:extract:agencies
    data:extract:places
    data:update:agencies
    thinking_sphinx:index
  )
end