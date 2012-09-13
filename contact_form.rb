
ENV["RACK_ENV"] ||= "production"

require 'bundler'
Bundler.setup
Bundler.require(:default, ENV["RACK_ENV"].to_sym)

helpers do
  def valid_name?(name)
    true if name && !name.empty?
  end

  def valid_email?(email)
    email_match = /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}/
    true if email && !(email =~ email_match).nil?
  end

  def valid_message?(message)
    true if message && !message.empty?
  end

  def to(domain)
    case domain
    when 'programatornavolnenoze.cz'
      'fandisek@gmail.com' #'pavelnovotny@programatornavolnenoze.cz'
    else
      false # do nothing
    end
  end
end

get '/' do
  return jsonp false unless to(params[:domain])

  @errors = {}
  @failure = false

  if !valid_name?(params[:name])
    @errors[:name] = true
    @failure = true
  end

  if !valid_email?(params[:email])
    @errors[:email] = true
    @failure = true
  end

  if !valid_message?(params[:message])
    @errors[:message] = true
    @failure = true
  end

  if @failure
    return jsonp @errors
  else
    Pony.mail(:to       => to(params[:domain]),
              :from     => params[:email],
              :subject  => params[:subject],
              :body     => params[:message])
  end

  return jsonp true

end
