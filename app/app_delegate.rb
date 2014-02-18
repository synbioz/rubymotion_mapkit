class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    mapViewController = MapViewController.alloc.init
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.rootViewController = mapViewController
    @window.makeKeyAndVisible
    true
  end
end
