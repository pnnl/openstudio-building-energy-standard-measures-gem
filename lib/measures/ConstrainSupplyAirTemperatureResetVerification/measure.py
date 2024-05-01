import openstudio
import logging

logger = logging.getLogger(__name__)

class ConstrainSupplyAirTemperatureResetVerification(openstudio.measure.ModelMeasure):
    def name(self):
        """
        Return the human readable name.
        Measure name should be the title case of the class name.
        """
        return "Supply Air Temperature Reset Verification"

    def description(self):
        """
        Human readable description
        """
        return "Verifies supply air temperature reset for a specified AirLoopHVAC."

    def modeler_description(self):
        """
        Human readable description of the modeling approach
        """
        return "Verifies supply air temperature reset for a specified AirLoopHVAC."

    def arguments(self, model):
        """
        Define arguments
        """
        args = openstudio.measure.OSArgumentVector()

        air_loop_name = openstudio.measure.OSArgument.makeStringArgument(
            "air_loop_name", True
        )
        args.append(air_loop_name)

        design_zone_cooling_air_temp = openstudio.measure.OSArgument.makeDoubleArgument(
            "design_zone_cooling_air_temp", True
        )
        args.append(design_zone_cooling_air_temp)
        # TODO: If the user doesn't provide a design_zone_cooling_air_temp, we can infer it from other modeling inputs

        return args

    def run(
        self,
        model: openstudio.model.Model,
        runner: openstudio.measure.OSRunner,
        user_arguments: openstudio.measure.OSArgumentMap,
    ):
        """
        Define what happens when the measure is run
        """
        super().run(model, runner, user_arguments)

        if not (runner.validateUserArguments(self.arguments(model), user_arguments)):
            return False

        air_loop_name = runner.getStringArgumentValue("air_loop_name", user_arguments)
        design_zone_cooling_air_temp = runner.getDoubleArgumentValue("design_zone_cooling_air_temp", user_arguments)

        runner.registerInitialCondition("Init")

        air_loop = model.getAirLoopHVACByName(air_loop_name)
        if not air_loop.get():
            runner.registerError(f"AirLoopHVAC '{air_loop_name}' not found in the model")
            return False
        
        air_loop = air_loop.get()

        supply_outlet_node = air_loop.supplyOutletNode()

        output_variable = openstudio.model.OutputVariable("System Node Temperature", model)
        output_variable.setName(f"{air_loop.name} Supply Outlet Temperature")
        output_variable.setKeyValue(f"{supply_outlet_node.name}")

        

        output_variables = model.getOutputVariables()

        logger.error(supply_outlet_node.name)

        # raise Exception(len(output_variables))
        # model.outputVariable("System Node Temperature", supply_outlet_node.handle)
        runner.registerInfo("Added OutputVariable for supply outlet node temperature")

        runner.registerFinalCondition("Done")
        return True


ConstrainSupplyAirTemperatureResetVerification().registerWithApplication()