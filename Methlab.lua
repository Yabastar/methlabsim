local configFileName = ".config.txt" -- Name of the config file

equipment = 1
methprice = 250
equipmentcost = 700
meth = 0
money = 0
evercooked = 0
evermoney = 0
-- Function to clear the terminal
local function clr()
         term.clear()
         term.setCursorPos(1, 1)
end
clr()
while true do
         print("1. Skip story\n2. Go through story (1.3 minutes)")
         answer = io.read()
         if answer == "1" then
                  break
         elseif answer == "2" then
                  shell.run("pastebin run fQURKZZf")
                  sleep(2)
                  break
         end
end
clr()
print("Meth Lab Simulator V103")
print("by SEROST")
-- Function to load variables from the config file
local function loadConfig()
         local configFile = io.open(configFileName, "r") -- Open the config file in read mode
         if configFile then
                  -- Read the contents of the config file
                  local configContent = configFile:read("*a")
                  io.close(configFile) -- Close the config file

                  -- Deserialize the config content from a basic serialization format
                  local config = load("return " .. configContent)()
                  if config then
                           -- Set the global variables from the config table
                           equipment = config.equipment or 1
                           methprice = config.methprice or math.random(200, 300)
                           equipmentcost = config.equipmentcost or 700
                           meth = config.meth or 0
                           money = config.money or 0
                           evercooked = config.evercooked or 0
                           evermoney = config.evermoney or 0
                           -- Add other variables here
                  end
         end
end

-- Function to save variables to the config file
local function saveConfig()
         local configFile = io.open(configFileName, "w") -- Open the config file in write mode
         if configFile then
                  -- Create a config table with the variables
                  local config = {
                           equipment = equipment,
                           methprice = methprice,
                           equipmentcost = equipmentcost,
                           meth = meth,
                           money = money,
                           evercooked = evercooked,
                           evermoney = evermoney
                           -- Add other variables here
                  }

                  -- Serialize the config table to a basic serialization format
                  local configContent = string.format("{ equipment = %d, methprice = %d, equipmentcost = %d, meth = %d, money = %d, evercooked = %d, evermoney = %d }",
                  config.equipment or 0, config.methprice or 0, config.equipmentcost or 0, config.meth or 0, config.money or 0, config.evercooked or 0, config.evermoney or 0)

                  -- Write the config content to the config file
                  configFile:write(configContent)
                  io.close(configFile) -- Close the config file
         end
end

-- Function to handle the menu options
local function handleMenu(options)
         while true do
                  print("Type the number corresponding to one of these options:")
                  for index, option in ipairs(options) do
                           print(index .. ". " .. option.name)
                  end
                  local temp1 = io.read()
                  local choice = tonumber(temp1)
                  if choice and options[choice] then
                           options[choice].action()
                           break -- Exit the loop after a valid option is chosen
                  else
                           clr()
                           print("Invalid option. Please try again.")
                  end
         end
end

-- Menu option functions
local function cookMeth()
         clr()
         print("Cooking meth...")
         sleep(0.5)
         print("You have cooked " .. (equipment / 2) .. " lb of meth.")
         meth = meth + (equipment / 2)
         evercooked = evercooked + (equipment / 2)
end

local function sellMeth()
         clr()
         caught = math.random(1,70)
         if caught ~= 1 then
                  print("Sold " .. meth .. " lb of meth. ($" .. (methprice * meth) .. ")")
                  money = money + (methprice * meth)
                  evermoney = evermoney + (methprice * meth)
                  type = math.random(1,2)
                  methprice = math.random(200,300)
                  meth = 0
         else
                  print("You were busted! They stole all of your meth and took $" .. (money * 0.1) .. "!")
                  meth = 0
                  money = (money - (money * 0.1))
         end
end

local function upgradeEquipment()
         clr()
         if money > equipmentcost then
                  equipment = equipment + 1
                  print("Upgraded equipment to level " .. equipment)
                  money = money - equipmentcost
                  equipmentcost = equipmentcost + 400
         else
                  print("You don't have enough! ($" .. equipmentcost .. " required)")
         end
end

local function checkBalance()
         clr()
         print("$" .. money)
end

local function exitProgram()
         clr()
         error("Program terminated by user")
end

local function stats()
         clr()
         print("Current money: $" .. money)
         print("Money earned: $" .. evermoney)
         print("Equipment level " .. equipment)
         print("Current meth: " .. meth .. "lb")
         print("Meth cooked: " .. evercooked .. "lb")
end

local options = {
         { name = "Cook meth", action = cookMeth },
         { name = "Sell meth", action = sellMeth },
         { name = "Upgrade equipment", action = upgradeEquipment },
         { name = "Check balance", action = checkBalance },
         { name = "Stats", action = stats },
         { name = "Exit", action = exitProgram }
}

-- Load variables from the config file
loadConfig()

-- Main game loop
while true do
         handleMenu(options)

         -- Backup variables to the config file after each menu action
         saveConfig()
end
