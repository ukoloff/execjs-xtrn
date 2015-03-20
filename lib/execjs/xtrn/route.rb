Rails::application.routes.draw do
  get "/rails/jsx" => ExecJS::Xtrn::Rack
end
