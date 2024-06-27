# insert your copyright here

require 'openstudio'
require 'openstudio/measure/ShowRunnerOutput'
require 'minitest/autorun'
require_relative '../measure.rb'
require 'fileutils'

class CreateTypicalBuildingTest < Minitest::Test

  def test_existing_geometry_w_conventional_values
    # create an instance of the measure
    measure = CreateTypicalBuilding.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    path = File.join("#{File.dirname(__FILE__)}",'source','ASHRAESmallOffice.osm')
    ospath = OpenStudio::Path.new(path)
    model = translator.loadModel(ospath)
    if model.empty?
      raise "Path '#{path}' is not a valid path to an OpenStudio Model"
    else
      model = model.get
    end

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    # If the argument has a default that you want to use, you don't need it in the hash
    args_hash = {}
    args_hash['geometry'] = 'Existing Geometry'
    args_hash['climate_zone'] = 'ASHRAE 169-2013-4A'
    args_hash['template'] = '90.1-2019'
    args_hash['hvac_type'] = 'PSZ-AC with gas coil'
    args_hash['user_hvac_mapping'] = 'FALSE'
    args_hash['add_constructions'] = 'TRUE'
    args_hash['wall_construction'] = 'Inferred'
    args_hash['add_space_type_loads'] = 'FALSE'
    args_hash['add_daylighting'] = 'TRUE'

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran correctly
    assert_equal('Success', result.value.valueName)
    assert(result.warnings.empty?)

    # save the model to test output directory
    output_file_path = File.join("#{File.dirname(__FILE__)}",'output','test_existing_geometry_w_conventional_values.osm')
    model.save(output_file_path, true)
  end

  def test_using_geometry_file_w_conventional_values
    # create an instance of the measure
    measure = CreateTypicalBuilding.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    current_dir = File.dirname(__FILE__)
    model_path = File.join(current_dir,'source','ASHRAESmallOffice.osm')
    ospath = OpenStudio::Path.new(model_path)
    model = translator.loadModel(ospath)
    if model.empty?
      raise "Path '#{model_path}' is not a valid path to an OpenStudio Model"
    else
      model = model.get
    end

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    # If the argument has a default that you want to use, you don't need it in the hash
    args_hash = {}
    args_hash['geometry'] = 'Retail Stripmall'
    args_hash['climate_zone'] = 'ASHRAE 169-2013-4A'
    args_hash['template'] = '90.1-2019'
    args_hash['hvac_type'] = 'PSZ-AC with gas coil'
    args_hash['user_hvac_mapping'] = 'FALSE'
    args_hash['add_constructions'] = 'TRUE'
    args_hash['wall_construction'] = 'Inferred'
    args_hash['add_space_type_loads'] = 'FALSE'
    args_hash['add_daylighting'] = 'TRUE'


    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran correctly
    assert_equal('Success', result.value.valueName)
    assert(result.warnings.empty?)

    # Assert that the geometry was swapped to a RetailStripMall
    assert(model.building.get.name.to_s == 'DOE Prototype RetailStripmall')

    output_file_path = File.join(current_dir,'output','test_using_geometry_file_w_conventional_values.osm')
  end

  def test_successful_hvac_mapping_json
    # create an instance of the measure
    measure = CreateTypicalBuilding.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    current_dir = File.dirname(__FILE__)
    model_path = File.join(current_dir,'source','ASHRAESmallOffice.osm')
    ospath = OpenStudio::Path.new(model_path)
    model = translator.loadModel(ospath)
    if model.empty?
      raise "Path '#{model_path}' is not a valid path to an OpenStudio Model"
    else
      model = model.get
    end

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    # If the argument has a default that you want to use, you don't need it in the hash
    args_hash = {}
    args_hash['geometry'] = 'Existing Geometry'
    args_hash['climate_zone'] = 'ASHRAE 169-2013-4A'
    args_hash['template'] = '90.1-2019'
    args_hash['hvac_type'] = 'JSON specified'
    args_hash['user_hvac_json_path'] = File.join("#{current_dir}",'source','hvac_mapping_path','hvac_zone_mapping.json')
    args_hash['add_constructions'] = 'TRUE'
    args_hash['wall_construction'] = 'Inferred'
    args_hash['add_space_type_loads'] = 'FALSE'
    args_hash['add_daylighting'] = 'TRUE'

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran correctly
    assert_equal('Success', result.value.valueName)
    assert(result.warnings.empty?)

    # save the model to test output directory
    output_file_path = File.join(current_dir,'output','test_successful_hvac_mapping_json.osm')
    model.save(output_file_path, true)

  end

  def test_double_multizone_airloop
    # create an instance of the measure
    measure = CreateTypicalBuilding.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    current_dir = File.dirname(__FILE__)
    model_path = File.join(current_dir,'source','ASHRAESmallOffice.osm')
    ospath = OpenStudio::Path.new(model_path)
    model = translator.loadModel(ospath)
    if model.empty?
      raise "Path '#{model_path}' is not a valid path to an OpenStudio Model"
    else
      model = model.get
    end

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    # If the argument has a default that you want to use, you don't need it in the hash
    args_hash = {}
    args_hash['geometry'] = 'Existing Geometry'
    args_hash['climate_zone'] = 'ASHRAE 169-2013-4A'
    args_hash['template'] = '90.1-2019'
    args_hash['hvac_type'] = 'JSON specified'
    args_hash['user_hvac_json_path'] = File.join("#{current_dir}",'source','hvac_mapping_path','hvac_zone_mapping_2_vav_hw_rh.json')
    args_hash['add_constructions'] = 'TRUE'
    args_hash['wall_construction'] = 'Inferred'
    args_hash['add_space_type_loads'] = 'FALSE'
    args_hash['add_daylighting'] = 'TRUE'

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran correctly
    assert_equal('Success', result.value.valueName)
    assert(result.warnings.empty?)

    # Check that two multizone air loops were created despite being specified the same way
    assert(model.getAirLoopHVACs.length == 2)

    # save the model to test output directory
    output_file_path = File.join(current_dir,'output','hvac_zone_mapping_2_vav_hw_rh.osm')

    model.save(output_file_path, true)

  end

  def test_double_single_zone_airloop
    # create an instance of the measure
    measure = CreateTypicalBuilding.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    current_dir = File.dirname(__FILE__)
    model_path = File.join(current_dir,'source','ASHRAESmallOffice.osm')
    ospath = OpenStudio::Path.new(model_path)
    model = translator.loadModel(ospath)
    if model.empty?
      raise "Path '#{model_path}' is not a valid path to an OpenStudio Model"
    else
      model = model.get
    end

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    # If the argument has a default that you want to use, you don't need it in the hash
    args_hash = {}
    args_hash['geometry'] = 'Existing Geometry'
    args_hash['climate_zone'] = 'ASHRAE 169-2013-4A'
    args_hash['template'] = '90.1-2019'
    args_hash['hvac_type'] = 'JSON specified'
    args_hash['user_hvac_json_path'] = File.join("#{current_dir}",'source','hvac_mapping_path','hvac_zone_mapping_2_psz_ac.json')
    args_hash['add_constructions'] = 'TRUE'
    args_hash['wall_construction'] = 'Inferred'
    args_hash['add_space_type_loads'] = 'FALSE'
    args_hash['add_daylighting'] = 'TRUE'


    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran correctly
    assert_equal('Success', result.value.valueName)
    assert(result.warnings.empty?)

    # Check that five air loops were created despite only two being specified. This is because they're single zone.
    # One for each zone in the building.
    assert(model.getAirLoopHVACs.length == 5)

    # save the model to test output directory
    output_file_path = File.join(current_dir,'output','hvac_zone_mapping_2_psz_ac.osm')
    model.save(output_file_path, true)

  end


  def test_invalid_user_hvac_mapping_json_parser_error
    # create an instance of the measure
    measure = CreateTypicalBuilding.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    current_dir = File.dirname(__FILE__)
    model_path = File.join(current_dir,'source','ASHRAESmallOffice.osm')
    ospath = OpenStudio::Path.new(model_path)
    model = translator.loadModel(ospath)
    if model.empty?
      raise "Path '#{model_path}' is not a valid path to an OpenStudio Model"
    else
      model = model.get
    end

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    # If the argument has a default that you want to use, you don't need it in the hash
    args_hash = {}
    args_hash['geometry'] = 'Existing Geometry'
    args_hash['climate_zone'] = 'ASHRAE 169-2013-4A'
    args_hash['template'] = '90.1-2019'
    args_hash['hvac_type'] = 'JSON specified'
    args_hash['user_hvac_json_path'] = File.join("#{current_dir}",'source','hvac_mapping_path','hvac_zone_mapping_invalid_json.json')
    args_hash['add_constructions'] = 'TRUE'
    args_hash['wall_construction'] = 'Inferred'
    args_hash['add_space_type_loads'] = 'FALSE'
    args_hash['add_daylighting'] = 'TRUE'

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran incorrectly
    assert_equal('Fail', result.value.valueName)

    # Ensure the error message reads invalid JSON
    assert(result.errors[0].logMessage.include? "JSON parser failed to read file")

  end

  def test_invalid_user_hvac_mapping_json
    # create an instance of the measure
    measure = CreateTypicalBuilding.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    current_dir = File.dirname(__FILE__)
    model_path = File.join(current_dir,'source','ASHRAESmallOffice.osm')
    ospath = OpenStudio::Path.new(model_path)
    model = translator.loadModel(ospath)
    if model.empty?
      raise "Path '#{model_path}' is not a valid path to an OpenStudio Model"
    else
      model = model.get
    end

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    # If the argument has a default that you want to use, you don't need it in the hash
    args_hash = {}
    args_hash['geometry'] = 'Existing Geometry'
    args_hash['climate_zone'] = 'ASHRAE 169-2013-4A'
    args_hash['template'] = '90.1-2019'
    args_hash['hvac_type'] = 'JSON specified'
    args_hash['user_hvac_json_path'] = File.join("#{current_dir}",'source','hvac_mapping_path','hvac_zone_mapping_broken.json')
    args_hash['add_constructions'] = 'TRUE'
    args_hash['wall_construction'] = 'Inferred'
    args_hash['add_space_type_loads'] = 'FALSE'
    args_hash['add_daylighting'] = 'TRUE'

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran incorrectly
    assert_equal('Fail', result.value.valueName)

    # Ensure the error message reads invalid JSON
    assert(result.errors[0].logMessage.include? "Ensure JSON follows the format specified under")

  end

  def test_missing_zones_user_hvac_mapping_json
    # create an instance of the measure
    measure = CreateTypicalBuilding.new

    # create runner with empty OSW
    osw = OpenStudio::WorkflowJSON.new
    runner = OpenStudio::Measure::OSRunner.new(osw)

    # load the test model
    translator = OpenStudio::OSVersion::VersionTranslator.new
    current_dir = File.dirname(__FILE__)
    model_path = File.join(current_dir,'source','ASHRAERetailStripmall.osm')
    ospath = OpenStudio::Path.new(model_path)
    model = translator.loadModel(ospath)
    if model.empty?
      raise "Path '#{model_path}' is not a valid path to an OpenStudio Model"
    else
      model = model.get
    end

    # get arguments
    arguments = measure.arguments(model)
    argument_map = OpenStudio::Measure.convertOSArgumentVectorToMap(arguments)

    # create hash of argument values.
    # If the argument has a default that you want to use, you don't need it in the hash
    args_hash = {}
    args_hash['geometry'] = 'Existing Geometry'
    args_hash['climate_zone'] = 'ASHRAE 169-2013-4A'
    args_hash['template'] = '90.1-2019'
    args_hash['hvac_type'] = 'JSON specified'
    args_hash['user_hvac_json_path'] = File.join("#{current_dir}",'source','hvac_mapping_path','hvac_zone_mapping.json')
    args_hash['add_constructions'] = 'TRUE'
    args_hash['wall_construction'] = 'Inferred'
    args_hash['add_space_type_loads'] = 'FALSE'
    args_hash['add_daylighting'] = 'TRUE'

    # populate argument with specified hash value if specified
    arguments.each do |arg|
      temp_arg_var = arg.clone
      if args_hash.key?(arg.name)
        assert(temp_arg_var.setValue(args_hash[arg.name]))
      end
      argument_map[arg.name] = temp_arg_var
    end

    # run the measure
    measure.run(model, runner, argument_map)
    result = runner.result

    # show the output
    show_output(result)

    # assert that it ran incorrectly
    assert_equal('Fail', result.value.valueName)

    # Ensure the error message communicates the zones that don't exist in the OSM
    assert(result.errors[0].logMessage.include? "The following zones don't exist in ")

  end

end
