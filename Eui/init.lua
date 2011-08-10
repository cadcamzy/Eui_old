local addon, engine = ...
engine[1] = {} -- E, functions, constants
engine[2] = {} -- C, config
engine[3] = {} -- L, localization
engine[4] = {} -- DB, database, post config load

EUI = engine --Allow other addons to use Engine

--[[

local E, C, L, DB = unpack(EUI)

other addons

local E,C,L = unpack(EUI)
]]