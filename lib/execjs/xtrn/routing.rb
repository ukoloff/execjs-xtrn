module ExecJS::Xtrn
  Rack = ->(arg){ExecJS::Xtrn.rack}

  def self.rack
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
      File.expand_path('../route.rb', __FILE__)
  end
end
