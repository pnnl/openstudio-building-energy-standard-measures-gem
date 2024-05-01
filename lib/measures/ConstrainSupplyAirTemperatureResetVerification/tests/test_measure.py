import pytest
import openstudio
import pathlib
import sys
from measure import ConstrainSupplyAirTemperatureResetVerification


class TestConstrainSupplyAirTemperatureResetVerification:
    def test_number_of_arguments_and_argument_names(self):
        """
        Test that the arguments are what we expect
        """
        # create an instance of the measure
        measure = ConstrainSupplyAirTemperatureResetVerification()

        # make an empty model
        model = openstudio.model.Model()

        # get arguments and test that they are expecting a failure
        # because the model doesn't have a chiller
        arguments = measure.arguments(model)

        # Create dummy chiller object
        air_loop = openstudio.model.AirLoopHVAC(model)
        air_loop.setName("Test Air Loop")

        # get arguments and test that they are what we are expecting
        arguments = measure.arguments(model)
        assert arguments.size() == 2
        assert arguments[0].name() == "air_loop_name"
        assert arguments[1].name() == "design_zone_cooling_air_temp"

    def test_good_argument_values(self):
        """
        Test running the measure with appropriate arguments, and that the
        measure runs fine and with expected results
        """

        measure = ConstrainSupplyAirTemperatureResetVerification()

        osw = openstudio.openstudioutilitiesfiletypes.WorkflowJSON()
        runner = openstudio.measure.OSRunner(osw)

        # make an empty model
        model = openstudio.model.Model()

        # Create dummy air loop object
        air_loop = openstudio.model.AirLoopHVAC(model)
        air_loop.setName("Test Air Loop")

        # get arguments and test that they are what we are expecting
        arguments = measure.arguments(model)
        argument_map = openstudio.measure.convertOSArgumentVectorToMap(arguments)

        args_dict = {}
        args_dict["air_loop_name"] = "Test Air Loop"
        args_dict["design_zone_cooling_air_temp"] = 40

        for arg in arguments:
            temp_arg_var = arg.clone()
            if arg.name() in args_dict:
                temp_arg_var.setValue(args_dict[arg.name()])
                # if arg.name() != "chiller_name":
                assert temp_arg_var.setValue(args_dict[arg.name()])
                argument_map[arg.name()] = temp_arg_var

        measure.run(model, runner, argument_map)
        result = runner.result()
        assert result.value().valueName() == "Success"

if __name__ == "__main__":
    pytest.main()