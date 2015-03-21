module ExecJS::Xtrn
  Rack=Proc.new do |arg|
    [
      200,
      {"Content-Type"=> "text/yaml"},
      [stats.as_json.to_yaml],
    ]
  end
end

class Rails::Application
  initializer :execjs_xtrn_stats do
    Rails.application.routes_reloader.paths <<
      File.expand_path('../routes.rb', __FILE__)
  end
end
