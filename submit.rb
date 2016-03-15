
$env = ENV["SUBMIT_ENV"] || ENV["RACK_ENV"] || 'development'

if ENV['DATABASE_URL']
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  dbconf = YAML::load(File.open(File.join("config", "database.yml")))
  ActiveRecord::Base.establish_connection(dbconf[ENV['PORT'].to_i]||dbconf["default"])
  ActiveRecord::Base.logger = Logger.new(File.open(File.join("log", "#{$env}.log"), 'a'))
end


class Form < ActiveRecord::Base
  self.table_name = 'public.forms_data'
  self.primary_key = 'id'

  def as_json(opt={})
    super(only: [:id, :fields])
  end
end


get '/form/:id' do
  begin
    json Form.find(params[:id]).as_json
  rescue
    json({errors: ["not-found"]}, status: 404)
  end
end


post '/form/:id' do
  begin
    form = Form.find(params[:id])
  rescue
    return json({error: "not-found"}, status: 404)
  end
  # get form fields and filter schema only fields
  fields = form.fields.map {|f|   f["name"]            }
  form.data = params.select{|key| fields.include?(key) }
  begin
    form.save!
  rescue
    return json({errors: forms.errors}, status: 412)
  end
  json({success: form.id}) # TODO return success message
end
