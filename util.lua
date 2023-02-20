
Util = {}

--Rounds any number to optional number of decimal places
--Based on forum: http://lua-users.org/wiki/SimpleRound
function Util:round(num, numDecimalPlaces)
  local numDecimal = numDecimalPlaces or 0
  assert(type(num) == "number", "num must be a number")
  assert(not (numDecimal < 0), "numDecimalPlaces cannot be negative")
  local mult = 10^numDecimal
  if num >= 0 then
    return math.floor(num * mult + 0.5) / mult
  end
  return math.ceil(num * mult - 0.5) / mult
end
