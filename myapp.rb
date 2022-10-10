# myapp.rb
require 'sinatra'
require "sinatra/reloader"
require 'json'
require 'prawn'

set :bind, '0.0.0.0'

get '/' do
  attendees = JSON.load_file("./attendees.json")
  erb :index, {:locals => {attendees: attendees}}
end

post '/attendee' do
  width = 283.4644
  height = 175.7479
  Prawn::Document.generate('explicit.pdf', page_layout: :landscape, page_size: [width, height], margin:[10,20]) do |pdf|
    pdf.stroke_bounds
    attendees = JSON.load_file("./attendees.json")
    attendee = attendees.find {_1["name"] == params['name']}
    pdf.define_grid(columns: 2, rows: 1, gutter: 30)
    pdf.rotate(270, origin: [height/2, width/2]) do
      pdf.translate(0,-97) do
      pdf.grid(0,0).bounding_box do

        pdf.image "./public/member_#{attendee["memberId"]}.jpeg", fit:[width/2, height/2], position: :center
      end

      pdf.grid(0,1).bounding_box do
        pdf.bounding_box([0,pdf.cursor], width: 100, height: 100) do
          pdf.font('Courier', size: 20) do
            pdf.text attendee["name"], align: :center
            pdf.image "./public/rorosyd-logo.png", fit:[width/4, height/4], position: :center
          end
        end
      end
    end
  end
  new_attendee_list = attendees.map do |i|
    if i["name"] == attendee["name"]
     i["printed"] = true
     i
    else
      i
    end
 end
 File.open("./attendees.json", 'w') { |file| file.write(new_attendee_list.to_json) }
 `lp explicit.pdf`
  end

  redirect "/"
end
