clearScreen.
set maxBattery to 925.
set panelsStauts to false.
SET opennableSolars to SHIP:partsnamed("solarPanels1").
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
        HybernateForPower.
    }
}

declare function HybernateForPower{
    if(BatteryPrc < 50)
    {
        print("Detected Low Power " + BatteryPrc).
        ToggleSolarPanels.
        wait 12.
        until BatteryPrc > 90 {
            print("Charging... Prc: " + BatteryPrc).
            wait 1.
        }
        ToggleSolarPanels.
        print("Battery Loaded " + BatteryPrc).
    }
}





MainProgram.
