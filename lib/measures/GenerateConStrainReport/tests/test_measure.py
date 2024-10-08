import pytest
import openstudio
import pathlib
from ..measure import GenerateConStrainReport
import logging


class TestGenerateConStrainReport:
    def test_number_of_arguments_and_argument_names(self):
        """
        Test that the arguments are what we expect
        """
        # create an instance of the measure
        measure = GenerateConStrainReport()
        arguments = measure.arguments()
        assert arguments.size() == 1
        assert arguments[0].name() == "workflow_path"

    def test_good_argument_values(self):
        """
        Test running the measure with appropriate arguments, and that the
        measure runs fine and with expected results
        """

        measure = GenerateConStrainReport()

        osw = openstudio.openstudioutilitiesfiletypes.WorkflowJSON()
        runner = openstudio.measure.OSRunner(osw)

        arguments = measure.arguments()
        argument_map = openstudio.measure.convertOSArgumentVectorToMap(arguments)

        args_dict = {}
        args_dict["workflow_path"] = (
            "tests/test_files/G36_demo_workflow.json"
        )

        for arg in arguments:
            temp_arg_var = arg.clone()
            if arg.name() in args_dict:
                temp_arg_var.setValue(args_dict[arg.name()])
                assert temp_arg_var.setValue(args_dict[arg.name()])
                argument_map[arg.name()] = temp_arg_var

        # Run measure
        measure.run(runner, argument_map)
        result = runner.result()
        assert result.value().valueName() == "Success"


if __name__ == "__main__":
    pytest.main()
