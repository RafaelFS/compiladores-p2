def generate_output_file code
  env_code = File.read("runtimeTemplate.rb")

  env_code.sub!("#<<MARKER_FOR_GENERATOR>>#", get_input_code(code))

  File.open("program.rb", "w") do |f|
    f.write env_code
  end
end

def get_input_code code
  "input_program = #{code}"
end