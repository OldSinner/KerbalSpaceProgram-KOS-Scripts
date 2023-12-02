//Init
clearScreen.


//Const Values
set maxBattery to 1725.
set NORTHPOLE to latlng( 90, 180).

//Const Objects
set panelsStauts to false.
set opennableSolars to SHIP:partsnamed("solarPanels1").


//Function of Rover
declare function BatteryPrc
{
    return (ceiling(ship:electriccharge) * 100)/maxBattery.
}

declare function ToggleSolarPanels
{
    for solar in opennableSolars
    {
          set module to solar:getmodule("ModuleDeployableSolarPanel").
          module:doaction("toggle solar panel",not panelsStauts).
    }
    set panelsStauts to not panelsStauts.
}

declare function MainProgram{
    until false
    {
        steerTowardNorth.
        HybernateForPower.
    }
}

declare function HybernateForPower{
    if(BatteryPrc < 50)
    {
        SET BRAKES TO true.
        LOCK WHEELTHROTTLE to 0.
        print("Detected Low Power " + BatteryPrc).
        ToggleSolarPanels.
        wait 12.
        until BatteryPrc > 60 {
            print("Charging... Prc: " + BatteryPrc).
            wait 2.
        }
        ToggleSolarPanels.
        print("Battery Loaded " + BatteryPrc).
        LOCK WHEELTHROTTLE to 1.
        SET BRAKES TO false.
    }
}

declare function steerTowardNorth
{
    set northAngle to abs(NORTHPOLE:bearing).
    if( northAngle > 5 and northAngle < 30 )
    {
        SET BRAKES TO true.
        LOCK WHEELTHROTTLE to 0.
        lock WHEELSTEERING to NORTHPOLE.
    }
    else if(northAngle > 30)
    {
        SET BRAKES TO false.
        LOCK WHEELTHROTTLE to 1.
        lock WHEELSTEERING to NORTHPOLE.
    }
    else
    {
        SET BRAKES TO false.
        LOCK WHEELTHROTTLE to 1.
        unlock WHEELSTEERING.
    }
}




MainProgram.
