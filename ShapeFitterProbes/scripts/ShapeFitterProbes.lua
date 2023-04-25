--[[----------------------------------------------------------------------------

  Application Name:
  ShapeFitterProbes

  Summary:
  Fitting jagged edge to line and plot all probe hits including outliers.

  How to Run:
  Starting this sample is possible either by running the app (F5) or
  debugging (F7+F10). Setting breakpoint on the first row inside the 'main'
  function allows debugging step-by-step after 'Engine.OnStarted' event.
  Results can be seen in the image viewer on the DevicePage.
  Restarting the Sample may be necessary to show images after loading the webpage.
  To run this Sample a device with SICK Algorithm API and AppEngine >= V2.5.0 is
  required. For example SIM4000 with latest firmware. Alternatively the Emulator
  in AppStudio 2.3 or higher can be used.

  More Information:
  Tutorial "Algorithms - Fitting and Measurement".

------------------------------------------------------------------------------]]
--Start of Global Scope---------------------------------------------------------

print('AppEngine Version: ' .. Engine.getVersion())

local DELAY = 1000 -- ms between visualization steps for demonstration purpose

-- Creating viewer
local viewer = View.create()

-- Setting up graphical overlay attributes
local regionDecoration = View.ShapeDecoration.create()
regionDecoration:setLineWidth(4):setLineColor(230, 230, 0) -- Yellow

local featureDecoration = View.ShapeDecoration.create()
featureDecoration:setLineWidth(4):setLineColor(75, 75, 255) -- Blue

local pointDecoration = View.ShapeDecoration.create()
pointDecoration:setLineWidth(4):setLineColor(230, 0, 0) -- Red
pointDecoration:setPointType('CROSS'):setPointSize(10)

local textDecoration = View.TextDecoration.create()
textDecoration:setSize(30):setPosition(20, 30)

--End of Global Scope-----------------------------------------------------------

--Start of Function and Event Scope---------------------------------------------

local function main()
  local img = Image.load('resources/ShapeFitterProbes.bmp')
  viewer:clear()
  viewer:addImage(img)
  viewer:present()
  Script.sleep(DELAY) -- for demonstration purpose only

  -- Defining edge region
  local edgeCenter = Point.create(310, 135)
  local edgeRect = Shape.createRectangle(edgeCenter, 550, 100, 0)
  local angle = math.pi / 2 -- pi/2 rad = 90 deg

  -- Fitting edge
  local fitter = Image.ShapeFitter.create()
  fitter:setFitMode('RANSAC')

  for i = 10, 100, 10 do
    fitter:setProbeCount(i)

    local edgeSegm, _ = fitter:fitLine(img, edgeRect:toPixelRegion(img), angle)
    local points = fitter:getEdgePoints()
    viewer:clear()
    viewer:addImage(img)
    viewer:addShape(points, pointDecoration)
    viewer:addShape(edgeSegm, featureDecoration)
    viewer:addShape(edgeRect, regionDecoration)
    viewer:addText('Probe count: ' .. i, textDecoration)
    viewer:present()
    Script.sleep(DELAY) -- for demonstration purpose only
  end
  print('App finished.')
end
--The following registration is part of the global scope which runs once after startup
--Registration of the 'main' function to the 'Engine.OnStarted' event
Script.register('Engine.OnStarted', main)

--End of Function and Event Scope-----------------------------------------------
