# myapp.rb
require 'sinatra'
require "sinatra/reloader"
require 'json'
require 'prawn'
#page_size: [28.3464566929,17.5748031496]
get '/' do
  attendees = JSON.load_file("./attendees.json")
  erb :index, {:locals => {attendees: attendees}}
end

post '/attendee' do
  width = 283.4644
  height = 175.7479
  rotation = 0
  landscape = rotation == 270
  orientation = landscape ? {page_size: [height, width]} : {page_size: [width,height]}

  require 'prawn-html'
  pdf = Prawn::Document.new(page_size: [height, width])
    attendee = JSON.load_file("./attendees.json").find {_1["memberId"] == params['id']}
  PrawnHtml.append_html(pdf, "<div style='background-image: url('./public/member_#{attendee[\"memberId\"]}.jpeg'>Just a test</div>")
  pdf.render_file('explicit.pdf')
  # Prawn::Document.generate('explicit.pdf', {}.merge(orientation )) do |pdf|

  #   pdf.define_grid(columns: 1, rows: 2, gutter: 0) if landscape
  #   pdf.define_grid(columns: 2, rows: 1, gutter: 0) unless landscape

  #   pdf.grid(0,0).bounding_box do
  #     image = pdf.image "./public/member_#{attendee["memberId"]}.jpeg", fit:[height/2, width/2]
  #     puts image.methods
  #   end

  #   pdf.grid(0,1).bounding_box do
  #     pdf.bounding_box([0,pdf.cursor], width: 100, height: 100) do
  #       pdf.font('Courier', size: 20) do
  #         pdf.text attendee["name"]
  #       end
  #     end
  #   end
  # end
  redirect "/"
end
