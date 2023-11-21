import openstudio
import copper as cp
import typing


class GenerateIPLVChillerElectricEIRPerformanceCurves(openstudio.measure.ModelMeasure):
    def name(self):
        """
        Return the human readable name.
        Measure name should be the title case of the class name.
        """
        return "Generate IPLV-specific Chiller Performance Curves for Chillers (Chiller:Electric:EIR)."

    def description(self):
        """
        Human readable description
        """
        return "This measure generates and assigns a set of performance curves to a chiller object that matches a target description including the chiller's integrated part load value (IPLV) for the Chiller:Electric:EIR model."

    def modeler_description(self):
        """
        Human readable description of the modeling approach
        """
        return "The measure relies on Copper (https://github.com/pnnl/copper) to generate sets of performance curves."

    def arguments(self, model: openstudio.model.Model):
        """
        Define arguments
        """
        args = openstudio.measure.OSArgumentVector()

        # Get chiller to be modify
        chiller_names = openstudio.StringVector()
        chillers = model.getChillerElectricEIRs()
        if len(chillers) > 0:
            for chiller in chillers:
                chiller_names.append(chiller.nameString())
        else:
            return False
        chiller_name = openstudio.measure.OSArgument.makeChoiceArgument(
            "chiller_name", chiller_names, True
        )
        chiller_name.setDisplayName("Chiller object name")

        # Chiller characteristics
        # Compressor type
        chiller_compressor_types = openstudio.StringVector()
        chiller_compressor_types.append("positive_displacement")
        chiller_compressor_types.append("centrifugal")
        chiller_compressor_type = openstudio.measure.OSArgument.makeChoiceArgument(
            "chiller_compressor_type", chiller_compressor_types, True
        )
        chiller_compressor_type.setDisplayName("Chiller compressor type")
        # Compressor speed control
        chiller_compressor_speed_controls = openstudio.StringVector()
        chiller_compressor_speed_controls.append("constant")
        chiller_compressor_speed_controls.append("variable")
        chiller_compressor_speed_control = (
            openstudio.measure.OSArgument.makeChoiceArgument(
                "chiller_speed_control", chiller_compressor_speed_controls, True
            )
        )
        chiller_compressor_speed_control.setDisplayName(
            "Chiller compressor speed control"
        )
        # Condenser type
        chiller_condenser_types = openstudio.StringVector()
        chiller_condenser_types.append("water")
        chiller_condenser_types.append("air")
        chiller_condenser_type = openstudio.measure.OSArgument.makeChoiceArgument(
            "chiller_condenser_type", chiller_condenser_types, True
        )
        chiller_condenser_type.setDisplayName("Chiller condenser type")
        # Capacity unit
        chiller_capacity_units = openstudio.StringVector()
        chiller_capacity_units.append("ton")
        chiller_capacity_units.append("kW")
        chiller_capacity_units.append("W")
        chiller_capacity_unit = openstudio.measure.OSArgument.makeChoiceArgument(
            "chiller_capacity_unit", chiller_capacity_units, True
        )
        chiller_capacity_unit.setDisplayName("Chiller capacity unit")
        # Reference capacity
        chiller_capacity = openstudio.measure.OSArgument.makeDoubleArgument(
            "chiller_capacity", True
        )
        chiller_capacity.setDisplayName("Chiller capacity")
        # Efficiency unit
        chiller_efficiency_units = openstudio.StringVector()
        chiller_efficiency_units.append("kW/ton")
        chiller_efficiency_units.append("cop")
        chiller_efficiency_units.append("eer")
        chiller_efficiency_unit = openstudio.measure.OSArgument.makeChoiceArgument(
            "chiller_efficiency_unit", chiller_efficiency_units, True
        )
        chiller_efficiency_unit.setDisplayName("Chiller efficiency unit")
        # Full load efficiency
        chiller_full_load_efficiency = openstudio.measure.OSArgument.makeDoubleArgument(
            "chiller_full_load_efficiency", True
        )
        chiller_full_load_efficiency.setDisplayName(
            "Full load efficiency of the chiller as per AHRI 550/590 rating conditions"
        )
        # Part load efficiency
        chiller_part_load_efficiency = openstudio.measure.OSArgument.makeDoubleArgument(
            "chiller_part_load_efficiency", True
        )
        chiller_part_load_efficiency.setDisplayName(
            "Part load efficiency (IPLV) of the chiller as per AHRI 550/590 rating conditions"
        )

        for arg in [
            chiller_name,
            chiller_compressor_type,
            chiller_compressor_speed_control,
            chiller_condenser_type,
            chiller_capacity_unit,
            chiller_capacity,
            chiller_efficiency_unit,
            chiller_full_load_efficiency,
            chiller_part_load_efficiency,
        ]:
            args.append(arg)

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

        # Get arguments
        chiller_name = runner.getStringArgumentValue("chiller_name", user_arguments)
        chiller_compressor_type = runner.getStringArgumentValue(
            "chiller_compressor_type", user_arguments
        )
        chiller_speed_control = runner.getStringArgumentValue(
            "chiller_speed_control", user_arguments
        )
        chiller_condenser_type = runner.getStringArgumentValue(
            "chiller_condenser_type", user_arguments
        )
        chiller_capacity_unit = runner.getStringArgumentValue(
            "chiller_capacity_unit", user_arguments
        )
        chiller_capacity = runner.getDoubleArgumentValue(
            "chiller_capacity", user_arguments
        )
        chiller_efficiency_unit = runner.getStringArgumentValue(
            "chiller_efficiency_unit", user_arguments
        )
        chiller_full_load_efficiency = runner.getDoubleArgumentValue(
            "chiller_full_load_efficiency", user_arguments
        )
        chiller_part_load_efficiency = runner.getDoubleArgumentValue(
            "chiller_part_load_efficiency", user_arguments
        )

        runner.registerInitialCondition("Init")

        # Create Chiller object with Copper
        chiller = cp.Chiller(
            compressor_type=chiller_compressor_type,
            condenser_type=chiller_condenser_type,
            compressor_speed=chiller_speed_control,
            ref_cap=chiller_capacity,
            ref_cap_unit=chiller_capacity_unit,
            full_eff=chiller_full_load_efficiency,
            full_eff_unit=chiller_efficiency_unit,
            part_eff=chiller_part_load_efficiency,
            part_eff_unit=chiller_efficiency_unit,
            part_eff_ref_std="ahri_550/590",
            model="ect_lwt",
            sim_engine="energyplus",
        )

        # Generate performance curves
        set_of_curves = chiller.generate_set_of_curves(
            vars=["eir-f-plr"], method="nearest_neighbor", tol=0.05, random_seed=1
        )

        # Create OpenStudio objects for the performance curves
        curves = {}
        for curve in set_of_curves:
            base_curve_name = f"{chiller_name} {chiller_full_load_efficiency}{chiller_efficiency_unit} FL {chiller_part_load_efficiency}{chiller_efficiency_unit} IPLV"
            if curve.type == "bi_quad":
                osm_curve = openstudio.model.CurveBiquadratic(model)
                osm_curve.setCoefficient1Constant(curve.coeff1)
                osm_curve.setCoefficient2x(curve.coeff2)
                osm_curve.setCoefficient3xPOW2(curve.coeff3)
                osm_curve.setCoefficient4y(curve.coeff4)
                osm_curve.setCoefficient5yPOW2(curve.coeff5)
                osm_curve.setCoefficient6xTIMESY(curve.coeff6)
                osm_curve.setMinimumValueofx(curve.x_min)
                osm_curve.setMaximumValueofx(curve.x_max)
                osm_curve.setMinimumValueofy(curve.y_min)
                osm_curve.setMaximumValueofy(curve.y_max)
            elif curve.type == "quad":
                osm_curve = openstudio.model.CurveQuadratic(model)
                osm_curve.setCoefficient1Constant(curve.coeff1)
                osm_curve.setCoefficient2x(curve.coeff2)
                osm_curve.setCoefficient3xPOW2(curve.coeff3)
                osm_curve.setMinimumValueofx(curve.x_min)
                osm_curve.setMaximumValueofx(curve.x_max)
            elif curve.type == "cubic":
                osm_curve = openstudio.model.CurveCubic(model)
                osm_curve.setCoefficient1Constant(curve.coeff1)
                osm_curve.setCoefficient2x(curve.coeff2)
                osm_curve.setCoefficient3xPOW2(curve.coeff3)
                osm_curve.setCoefficient4xPOW3(curve.coeff3)
                osm_curve.setMinimumValueofx(curve.x_min)
                osm_curve.setMaximumValueofx(curve.x_max)
            osm_curve.setName(f"{base_curve_name} {curve.out_var}")
            curves[curve.out_var] = osm_curve

        # Assign the performance curves to the chiller object
        for chiller in model.getChillerElectricEIRs():
            if chiller.nameString() == chiller_name:
                chiller.setElectricInputToCoolingOutputRatioFunctionOfTemperature(
                    curves["eir-f-t"]
                )
                chiller.setCoolingCapacityFunctionOfTemperature(curves["cap-f-t"])
                chiller.setElectricInputToCoolingOutputRatioFunctionOfPLR(
                    curves["eir-f-plr"]
                )

        runner.registerFinalCondition(
            f"Performance curves have been assigned to the {chiller_name} chiller object."
        )
        return True


GenerateIPLVChillerElectricEIRPerformanceCurves().registerWithApplication()
