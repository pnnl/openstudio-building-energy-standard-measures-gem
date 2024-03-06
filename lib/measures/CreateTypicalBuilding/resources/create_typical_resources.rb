module CreateTypicalBldgConstants

  CLIMATE_ZONES = ['Lookup From Model',  'ASHRAE 169-2013-1A', 'ASHRAE 169-2013-2A', 'ASHRAE 169-2013-2B',
                   'ASHRAE 169-2013-3A', 'ASHRAE 169-2013-3B', 'ASHRAE 169-2013-3C', 'ASHRAE 169-2013-4A',
                   'ASHRAE 169-2013-4B', 'ASHRAE 169-2013-4C', 'ASHRAE 169-2013-5A', 'ASHRAE 169-2013-5B',
                   'ASHRAE 169-2013-6A', 'ASHRAE 169-2013-6B', 'ASHRAE 169-2013-7A', 'ASHRAE 169-2013-8A']

  GEOMETRY_SELECTIONS = ['Existing Geometry',
                         'Small Office',
                         'Small Hotel',
                         'Secondary School',
                         'Retail Stripmall',
                         'Quick Service Restaurant',
                         'Primary School',
                         'Outpatient Medical Office',
                         'Midrise Apartment',
                         'Medium Office',
                         'Large Office',
                         'Large Hotel',
                         'Laboratory',
                         'Hospital',
                         'Highrise Apartment',
                         'Full Service Restaurant',
                         'Courthouse',
                         'College'
  ]

  GEOMETRY_FILES_HASH ={

    'Small Office' => 'ASHRAESmallOffice.osm',
    'Small Hotel'=> 'ASHRAESmallHotel.osm',
    'Secondary School'=> 'ASHRAESecondarySchool.osm',
    'Retail Stripmall' => 'ASHRAERetailStripmall.osm',
    'Quick Service Restaurant' => 'ASHRAEQuickServiceRestaurant.osm',
    'Primary School' => 'ASHRAEPrimarySchool.osm',
    'Outpatient Medical Office' => 'ASHRAEOutpatient.osm',
    'Midrise Apartment' => 'ASHRAEMidriseApartment.osm',
    'Medium Office' => 'ASHRAEMediumOffice.osm',
    'Large Office' => 'ASHRAELargeOffice.osm',
    'Large Hotel' => 'ASHRAELargeHotel.osm',
    'Laboratory' => 'ASHRAELaboratory.osm',
    'Hospital' => 'ASHRAEHospital.osm',
    'Highrise Apartment' => 'ASHRAEHighriseApartment.osm',
    'Full Service Restaurant' => 'ASHRAEFullServiceRestaurant.osm',
    'Courthouse' => 'ASHRAECourthouse.osm',
    'College' => 'ASHRAECollege.osm'
  }

  HVAC_TYPES = ['Inferred',
                'JSON specified',
                'Baseboard central air source heat pump',
                'Baseboard district hot water',
                'Baseboard electric',
                'Baseboard gas boiler',
                'Direct evap coolers with baseboard central air source heat pump',
                'Direct evap coolers with baseboard district hot water',
                'Direct evap coolers with baseboard electric',
                'Direct evap coolers with baseboard gas boiler',
                'Direct evap coolers with forced air furnace',
                'Direct evap coolers with gas unit heaters',
                'Direct evap coolers with no heat',
                'DOAS with fan coil air-cooled chiller with baseboard electric',
                'DOAS with fan coil air-cooled chiller with boiler',
                'DOAS with fan coil air-cooled chiller with central air source heat pump',
                'DOAS with fan coil air-cooled chiller with district hot water',
                'DOAS with fan coil air-cooled chiller with gas unit heaters',
                'DOAS with fan coil air-cooled chiller with no heat',
                'DOAS with fan coil chiller with baseboard electric',
                'DOAS with fan coil chiller with boiler',
                'DOAS with fan coil chiller with central air source heat pump',
                'DOAS with fan coil chiller with district hot water',
                'DOAS with fan coil chiller with gas unit heaters',
                'DOAS with fan coil chiller with no heat',
                'DOAS with fan coil district chilled water with baseboard electric',
                'DOAS with fan coil district chilled water with boiler',
                'DOAS with fan coil district chilled water with central air source heat pump',
                'DOAS with fan coil district chilled water with district hot water',
                'DOAS with fan coil district chilled water with gas unit heaters',
                'DOAS with fan coil district chilled water with no heat',
                'DOAS with VRF',
                'DOAS with water source heat pumps cooling tower with boiler',
                'DOAS with water source heat pumps district chilled water with district hot water',
                'DOAS with water source heat pumps fluid cooler with boiler',
                'DOAS with water source heat pumps with ground source heat pump',
                'Fan coil air-cooled chiller with boiler',
                'Fan coil air-cooled chiller with baseboard electric',
                'Fan coil air-cooled chiller with central air source heat pump',
                'Fan coil air-cooled chiller with district hot water',
                'Fan coil air-cooled chiller with gas unit heaters',
                'Fan coil air-cooled chiller with no heat',
                'Fan coil chiller with baseboard electric',
                'Fan coil chiller with boiler',
                'Fan coil chiller with central air source heat pump',
                'Fan coil chiller with district hot water',
                'Fan coil chiller with gas unit heaters',
                'Fan coil chiller with no heat',
                'Fan coil district chilled water with baseboard electric',
                'Fan coil district chilled water with boiler',
                'Fan coil district chilled water with central air source heat pump',
                'Fan coil district chilled water with district hot water',
                'Fan coil district chilled water with gas unit heaters',
                'Fan coil district chilled water with no heat',
                'Forced air furnace',
                'Gas unit heaters',
                'Packaged VAV Air Loop with Boiler', # second enumeration for backwards compatibility with Tenant Star project
                'PSZ-AC district chilled water with baseboard district hot water',
                'PSZ-AC district chilled water with baseboard electric',
                'PSZ-AC district chilled water with baseboard gas boiler',
                'PSZ-AC district chilled water with central air source heat pump',
                'PSZ-AC district chilled water with district hot water',
                'PSZ-AC district chilled water with electric coil',
                'PSZ-AC district chilled water with gas boiler',
                'PSZ-AC district chilled water with gas coil',
                'PSZ-AC district chilled water with gas unit heaters',
                'PSZ-AC district chilled water with no heat',
                'PSZ-AC with baseboard district hot water',
                'PSZ-AC with baseboard electric',
                'PSZ-AC with baseboard gas boiler',
                'PSZ-AC with central air source heat pump',
                'PSZ-AC with district hot water',
                'PSZ-AC with electric coil',
                'PSZ-AC with gas boiler',
                'PSZ-AC with gas coil',
                'PSZ-AC with gas unit heaters',
                'PSZ-AC with no heat',
                'PSZ-HP',
                'PTAC with baseboard district hot water',
                'PTAC with baseboard electric',
                'PTAC with baseboard gas boiler',
                'PTAC with central air source heat pump',
                'PTAC with district hot water',
                'PTAC with electric coil',
                'PTAC with gas boiler',
                'PTAC with gas coil',
                'PTAC with gas unit heaters',
                'PTAC with no heat',
                'PTHP',
                'PVAV with central air source heat pump reheat',
                'PVAV with district hot water reheat',
                'PVAV with gas boiler reheat',
                'PVAV with gas heat with electric reheat',
                'PVAV with PFP boxes',
                'Residential AC with baseboard central air source heat pump',
                'Residential AC with baseboard district hot water',
                'Residential AC with baseboard electric',
                'Residential AC with baseboard gas boiler',
                'Residential AC with no heat',
                'Residential AC with residential forced air furnace',
                'Residential forced air furnace',
                'Residential heat pump',
                'Residential heat pump with no cooling',
                'VAV air-cooled chiller with central air source heat pump reheat',
                'VAV air-cooled chiller with district hot water reheat',
                'VAV air-cooled chiller with gas boiler reheat',
                'VAV air-cooled chiller with gas coil reheat',
                'VAV air-cooled chiller with no reheat with baseboard electric',
                'VAV air-cooled chiller with no reheat with gas unit heaters',
                'VAV air-cooled chiller with no reheat with zone heat pump',
                'VAV air-cooled chiller with PFP boxes',
                'VAV chiller with central air source heat pump reheat',
                'VAV chiller with district hot water reheat',
                'VAV chiller with gas boiler reheat',
                'VAV chiller with gas coil reheat',
                'VAV chiller with no reheat with baseboard electric',
                'VAV chiller with no reheat with gas unit heaters',
                'VAV chiller with no reheat with zone heat pump',
                'VAV chiller with PFP boxes',
                'VAV district chilled water with central air source heat pump reheat',
                'VAV district chilled water with district hot water reheat',
                'VAV district chilled water with gas boiler reheat',
                'VAV district chilled water with gas coil reheat',
                'VAV district chilled water with no reheat with baseboard electric',
                'VAV district chilled water with no reheat with gas unit heaters',
                'VAV district chilled water with no reheat with zone heat pump',
                'VAV district chilled water with PFP boxes',
                'VRF',
                'Water source heat pumps cooling tower with boiler',
                'Water source heat pumps district chilled water with district hot water',
                'Water source heat pumps fluid cooler with boiler',
                'Water source heat pumps with ground source heat pump',
                'Window AC with baseboard central air source heat pump',
                'Window AC with baseboard district hot water',
                'Window AC with baseboard electric',
                'Window AC with baseboard gas boiler',
                'Window AC with forced air furnace',
                'Window AC with no heat',
                'Window AC with unit heaters']

  STANDARD_ENERGY_CODES = ['DOE Ref 1980-2004', 'DOE Ref Pre-1980',
                           '90.1-2004', '90.1-2007', '90.1-2010',
                           '90.1-2013', '90.1-2016', '90.1-2019']

end