# frozen_string_literal: true
require "openstudio"
require 'openstudio/measure/ShowRunnerOutput'
require 'minitest/autorun'
require_relative '../measure.rb'
require 'fileutils'
require 'openstudio-standards'

FILE_DIR = File.dirname(__FILE__)


class CreateBaselineBuildingTest < Minitest::Test

  def test__prm_num_parameters_success
    # create an instance of the measure
    measure = CreateBaselineBuilding.new
    # make an empty model
    model = OpenStudio::Model::Model.new

    # get arguments and test that they are what we are expecting
    arguments = measure.arguments(model)
    assert_equal(11, arguments.size)

    # make sure parameters names are matching
    count = -1
    assert_equal('building_type_wwr', arguments[count += 1].name)
    assert_equal('building_type_swh', arguments[count += 1].name)
    assert_equal('building_type_hvac', arguments[count += 1].name)
    assert_equal('climate_zone', arguments[count += 1].name)
    assert_equal('exempt_from_rotations', arguments[count += 1].name)
    assert_equal('exempt_from_unmet_load_hours_check', arguments[count += 1].name)
    assert_equal('user_data', arguments[count += 1].name)
    assert_equal('user_data_path', arguments[count += 1].name)
    assert_equal('evaluation_package', arguments[count += 1].name)
    assert_equal('evaluation_package_path', arguments[count += 1].name)
    assert_equal('debug', arguments[count += 1].name)
  end

  def test__prm_measure_failed
    # create an instance of the measure
    measure = CreateBaselineBuilding.new
    # make an empty model
    model = OpenStudio::Model::Model.new

    # get arguments and test that they are what we are expecting
    # provide a bad parameter to ensure the choice is enforced.
    arguments = measure.arguments(model)
    assert(!arguments[0].setValue('Others'))
  end
end