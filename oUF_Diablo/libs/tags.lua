  
  --get the addon namespace
  local addon, ns = ...  
  
  --get oUF namespace (just in case needed)
  local oUF = ns.oUF or oUF  
  
  --get the config
  local cfg = ns.cfg
  
  --get the functions
  local func = ns.func
    
  ---------------------------------------------
  -- TAGS
  ---------------------------------------------
  
  --rgb to hex func
  local function RGBPercToHex(r, g, b)
    r = r <= 1 and r >= 0 and r or 1
    g = g <= 1 and g >= 0 and g or 1
    b = b <= 1 and b >= 0 and b or 1
    return string.format("%02x%02x%02x", r*255, g*255, b*255)
  end
  
  ---------------------------------------------
  
  --color tag
  oUF.Tags["diablo:color"] = function(unit)
    local color = { r=1, g=1, b=1, }
    if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
      color = {r = 0.4, g = 0.4, b = 0.4}
    elseif UnitIsPlayer(unit) then
      color = rRAID_CLASS_COLORS[select(2, UnitClass(unit))] or RAID_CLASS_COLORS[select(2, UnitClass(unit))]
    elseif UnitIsUnit(unit, "pet")  then
      color = cfg.happycolors[GetPetHappiness()]
    else
      color = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
    end
    if color then
      return RGBPercToHex(color.r,color.g,color.b)
    else
      return "ffffff"
    end
  end
  
  ---------------------------------------------

  --colorsimple tag
  oUF.Tags["diablo:colorsimple"] = function(unit)
    local color = { r=1, g=1, b=1, }
    if UnitIsDeadOrGhost(unit) or not UnitIsConnected(unit) then
      color = {r = 0.4, g = 0.4, b = 0.4}
    end
    if color then
      return RGBPercToHex(color.r,color.g,color.b)
    else
      return "ffffff"
    end
  end
  
  ---------------------------------------------
  
  --name tag
  oUF.Tags["diablo:name"] = function(unit, rolf) 
    local color = oUF.Tags["diablo:color"](unit)
    local name = UnitName(rolf or unit)
    return "|cff"..color..(name or "").."|r"
  end
  oUF.TagEvents["diablo:name"] = "UNIT_NAME_UPDATE UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"
  
  ---------------------------------------------
  
  --hp value
  oUF.Tags["diablo:hpval"] = function(unit) 
    local color = oUF.Tags["diablo:colorsimple"](unit)
    local hpval
    if UnitIsDeadOrGhost(unit) then
      hpval = "dead"
    elseif not UnitIsConnected(unit) then
      hpval = "off"
    else
      hpval = func.numFormat(UnitHealth(unit) or 0).." / "..oUF.Tags["perhp"](unit).."%"
    end
    return "|cff"..color..(hpval or "").."|r"
  end
  oUF.TagEvents["diablo:hpval"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"
  
    ---------------------------------------------
  
  --short hp value
  oUF.Tags["diablo:shorthpval"] = function(unit) 
    local color = oUF.Tags["diablo:colorsimple"](unit)
    local hpval
    if UnitIsDeadOrGhost(unit) then
      hpval = "dead"
    elseif not UnitIsConnected(unit) then
      hpval = "off"
    else
      hpval = func.numFormat(UnitHealth(unit) or 0)
    end
    return "|cff"..color..(hpval or "").."|r"
  end
  oUF.TagEvents["diablo:shorthpval"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"
  
  ---------------------------------------------
  
  --power value
  oUF.Tags["diablo:ppval"] = function(unit) 
    local ppval = func.numFormat(UnitPower(unit) or 0).." / "..oUF.Tags["perpp"](unit).."%"
    return ppval or ""
  end
  oUF.TagEvents["diablo:ppval"] = "UNIT_POWER UNIT_MAXPOWER"
  
  ---------------------------------------------
  
  oUF.Tags["diablo:misshp"] = function(unit) 
    local color = oUF.Tags["diablo:colorsimple"](unit)
    local hpval
    if UnitIsDeadOrGhost(unit) then
      hpval = "dead"
    elseif not UnitIsConnected(unit) then
      hpval = "off"
    else
      local max, min = UnitHealthMax(unit), UnitHealth(unit)
      if max-min > 0 then
        hpval = "-"..func.numFormat(max-min)
      end
    end    
    return "|cff"..color..(hpval or "").."|r"
  end
  oUF.TagEvents["diablo:misshp"] = "UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"
  
  ---------------------------------------------
  
  oUF.Tags["diablo:raidhp"] = function(unit, rolf) 
    local color = oUF.Tags["diablo:color"](unit)
    local hpval
    if UnitIsDeadOrGhost(unit) then
      hpval = "dead"
    elseif not UnitIsConnected(unit) then
      hpval = "off"
    else
      local max, min = UnitHealthMax(unit), UnitHealth(unit)
      if max-min > 0 then
        hpval = "-"..func.numFormat(max-min)
        --rewrite color to white
        color = "ffffff"
      else
        hpval = UnitName(rolf or unit)
      end
    end    
    return "|cff"..color..(hpval or "").."|r"
  end
  oUF.TagEvents["diablo:raidhp"] = "UNIT_NAME_UPDATE UNIT_HEALTH UNIT_MAXHEALTH UNIT_CONNECTION"
  
  ---------------------------------------------
  