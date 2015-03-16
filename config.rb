require "extensions/views"

activate :views
activate :directory_indexes

set :relative_links, true
set :css_dir, 'assets/stylesheets'
set :js_dir, 'assets/javascripts'
set :images_dir, 'assets/images'
set :fonts_dir, 'assets/fonts'
set :layout, 'layouts/application'

configure :development do
 activate :livereload
end

configure :build do
  # Relative assets needed to deploy to Github Pages
  activate :relative_assets
  # Assumes the file source/about/template.html.erb exists
  data.playground.position.each do |id , position|
    proxy "/positions/#{position.jobTitle.parameterize}.html", "/positions/template.html", :locals => { :position => position }, :ignore => true
  end
end

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.method = :git
end

# before build hooks
before_build do |builder|
  print "Before build we look for changes in Contentful"
  system("middleman contentful")
end

  # Contentful plugin 
  activate :contentful do |f|
    f.space         = {playground: '12yz202mwxwc'}
    f.access_token  = '73d810b86f8ca023c3012098c76fe0bb9cc195b24b97fa3ebdc2026ff5bc8167'
    f.cda_query     = { content_type: '5L6cg0jdReS4KM0eO8QcGY', include: 1 }
    f.content_types = { position: '5L6cg0jdReS4KM0eO8QcGY'}
  end 

helpers do
  def nav_link(link_text, page_url, options = {})
    options[:class] ||= ""
    if current_page.url.length > 1
      current_url = current_page.url.chop
    else
      current_url = current_page.url
    end
    options[:class] << " active" if page_url == current_url
    link_to(link_text, page_url, options)
  end 
end
