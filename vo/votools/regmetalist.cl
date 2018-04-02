#{  REGMETALIST -- List the queryable metadata in a Registry resource.

procedure regmetalist ()

bool	all = no	

begin

  if (all) {
    print ("Title")
    print ("ShortName ")
    print ("Identifier")
    print ("ServiceURL")
    print ("ReferenceURL")
    print ("Description")
    print ("Subject")
    print ("ResourceType")
    print ("Type")
    print ("Creator")
    print ("Facility")
    print ("Instrument")
    print ("Contributor")
    print ("CoverageSpatial")
    print ("CoverageTemporal")
    print ("CoverageSpectral")
    print ("ContentLevel")
    print ("Version")

    print (" ")
    print (" ")
  }

  print("        COLUMNS FOR ALL RESOURCES        COLUMNS FOR CONE SERVICES")
  print("        dbid                             MaxSearchRadius")
  print("        status                           MaxRecords")
  print("        Identifier                       VOTableColumns")
  print("        Title")
  print("        ShortName")
  print("        CurationPublisherName            COLUMNS FOR SIAP SERVICES")
  print("        CurationPublisherIdentifier      VOTableColumns")
  print("        CurationPublisherDescription     ImageServiceType")
  print("        CurationPublisherReferenceURL    MaxqueryRegionSizeLat")
  print("        CurationCreatorName              MaxqueryRegionSizeLong")
  print("        CurationCreatorLogo              MaxImageExtentLat")
  print("        CurationContributor              MaxImageExtentLong")
  print("        CurationDate                     MaxImageSizeLat")
  print("        CurationVersion                  MaxImageSizeLong")
  print("        CurationContactName              MaxFileSize")
  print("        CurationContactEmail             MaxRecords")
  print("        CurationContactAddress")
  print("        CurationContactPhone")
  print("        Subject                          COLUMNS FOR SKYNODE SERVICES")
  print("        Description                      Compliance")
  print("        ReferenceURL                     Latitude")
  print("        Type                             Longitude")
  print("        Facility                         PrimaryTable")
  print("        Instrument                       PrimaryKey")
  print("        ContentLevel                     MaxRecords")
  print("        ModificationDate")
  print("        ServiceURL")
  print("        CoverageSpatial")
  print("        CoverageSpectral")
  print("        CoverageTemporal")
  print("        CoverageRegionOfRegard")
  print("        ResourceType")
  print("        xml")
  print("        harvestedfrom")
  print("        harvestedfromDate")
  print("        footprint")
  print("        validationLevel")
end