module ExecJS::Xtrn::Rack
  Formats=YAML.load <<-EOY
    -:
      mime: text/x-yaml
      dump: YAML
    json:
      mime: appication/json
      dump: JSON
    html:
      mime: text/html
      dump: self
  EOY

  Formats.each {|k, v| v['dump']=instance_eval v['dump']}

  def self.stats
    ExecJS::Xtrn.stats.as_json
  end

  def self.call req
    f=Formats[req['action_dispatch.request.path_parameters'][:format]] ||
      Formats['-']
    [
      200,
      {"Content-Type"=> f['mime']},
      [f['dump'].dump(stats)],
    ]
  end

  # Dump as HTML
  def self.dump s
    'Hi there!'
  end
end

class Rails::Application
  initializer :execjs_xtrn_stats do
    Rails.application.routes_reloader.paths <<
      File.expand_path('../routes.rb', __FILE__)
  end
end
