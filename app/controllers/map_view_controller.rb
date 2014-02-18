class MapViewController < UIViewController

  def loadView
    self.view = UIView.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    self.view.backgroundColor = UIColor.whiteColor

    @mapView = mapView
    @locationField = locationField
    @locationField.delegate = self

    self.view.addSubview @mapView
    self.view.addSubview segmentedControl
    self.view.addSubview @locationField

    userLocation
  end

  def locationManager(manager, didUpdateToLocation:newLocation, fromLocation:oldLocation)
    if newLocation != oldLocation
      region = MKCoordinateRegionMake(newLocation.coordinate, MKCoordinateSpanMake(0.05, 0.05))
      @mapView.setRegion region
    end
  end

  def locationManager(manager, didFailWithError:error)
    puts "error location user"
  end

  private

  def mapView
    topMargin = 100
    width     = UIScreen.mainScreen.bounds.size.width
    height    = UIScreen.mainScreen.bounds.size.height - topMargin

    view = MKMapView.alloc.initWithFrame([[0, topMargin], [width, height]])
    view.mapType = ::MKMapTypeStandard

    coordinates = CLLocationCoordinate2DMake(50.6308091, 3.0210861)
    region      = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(0.05, 0.05))
    view.setRegion region

    synbioz = Annotation.alloc.initWithCoordinate(coordinates, title: "Synbioz", subtitle: "2, rue Hegel, 59000, Lille, France")
    view.addAnnotation synbioz

    view
  end

  def segmentedControl
    segmentedControl = UISegmentedControl.alloc.initWithItems(['Standard', 'Satellite', 'Hybride'])
    segmentedControl.frame = [[20, UIScreen.mainScreen.bounds.size.height - 60], [280,40]]
    segmentedControl.selectedSegmentIndex = 0
    segmentedControl.addTarget(self,
                              action:"switchMapType:",
                              forControlEvents:UIControlEventValueChanged)
    segmentedControl
  end

  def switchMapType(segmentedControl)
    @mapView.mapType = case segmentedControl.selectedSegmentIndex
      when 0 then MKMapTypeStandard
      when 1 then MKMapTypeSatellite
      when 2 then MKMapTypeHybrid
    end
  end

  def locationField
    field = UITextField.alloc.initWithFrame([[10,30],[UIScreen.mainScreen.bounds.size.width-20,30]])
    field.borderStyle = UITextBorderStyleRoundedRect

    field
  end

  def textFieldShouldReturn (textField)
    @locationField.resignFirstResponder

    geocoder = CLGeocoder.alloc.init
    geocoder.geocodeAddressString @locationField.text,
                                  completionHandler: lambda { |places, error|
                                    if places.any?
                                      coordinates = places.first.location.coordinate
                                      region = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(0.05, 0.05))
                                      @mapView.setRegion region
                                    end
                                  }
  end

  def userLocation
    if (CLLocationManager.locationServicesEnabled)
      @location_manager = CLLocationManager.alloc.init
      @location_manager.desiredAccuracy = KCLLocationAccuracyKilometer
      @location_manager.delegate = self
      @location_manager.purpose = "Permet d'initialiser la carte sur votre position"
      @location_manager.startUpdatingLocation
    end
  end
end
