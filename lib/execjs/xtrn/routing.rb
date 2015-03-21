module ExecJS::Xtrn
  Racks=YAML.load <<-EOY
    -:
      mime: text/x-yaml
      dump: YAML
    json:
      mime: appication/json
      dump: JSON
  EOY
  Rack=Proc.new do |req|
    f=Racks[req['action_dispatch.request.path_parameters'][:format]]||Racks['-']
    [
      200,
      {"Content-Type"=> f['mime']},
      [f['dump'].constantize.dump(stats.as_json)],
    ]
  end
end

class Rails::Application
  initializer :execjs_xtrn_stats do
    Rails.application.routes_reloader.paths <<
      File.expand_path('../routes.rb', __FILE__)
  end
end
