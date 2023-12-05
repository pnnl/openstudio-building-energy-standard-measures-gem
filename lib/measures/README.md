# Generate IPLV-specific Chiller Performance Curves for Chillers
## Description
This measure generates and assigns a set of performance curves to a chiller object that matches a target description including the chiller's integrated part load value (IPLV) for the Chiller:Electric:EIR model.
## Modeler Description
## Measure Type
ModelMeasure
## Taxonomy
## Arguments
### Chiller Object Name
**Name:** chiller_name,
**Type:** Choice,
**Required:** true,
**Model Dependent:** true
### Chiller Compressor Type
**Name:** chiller_compressor_type,
**Type:** Choice,
**Required:** true,
**Model Dependent:** false
### Chiller Compressor Speed Control
**Name:** chiller_compressor_speed_control,
**Type:** Choice,
**Required:** true,
**Model Dependent:** false
### Chiller Condenser Type
**Name:** chiller_condenser_type,
**Type:** Choice,
**Required:** true,
**Model Dependent:** false
### Chiller Capacity Unit
**Name:** chiller_capacity_unit,
**Type:** Choice,
**Required:** true,
**Model Dependent:** false
### Chiller Efficiency Unit
**Name:** chiller_efficiency_unit,
**Type:** Choice,
**Required:** true,
**Model Dependent:** false
### Chiller Full Load Efficiency
**Name:** chiller_full_load_efficiency,
**Type:** Double,
**Required:** true,
**Model Dependent:** false
### Chiller Part Load Efficiency
**Name:** chiller_part_load_efficiency,
**Type:** Double,
**Required:** true,
**Model Dependent:** false
