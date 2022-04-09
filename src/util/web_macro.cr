macro layout(name)
  begin
    render "src/views/#{{{name}}}.html.ecr", "src/views/layout.html.ecr"
  rescue exception
    Log.error { exception.to_s }
  end
end

macro render_component(name)
  render "src/views/components/#{{{name}}}.html.ecr"
end

macro script(name)
  render "public/javascript/#{{{name}}}.js"
end
