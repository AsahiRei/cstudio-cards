--DAL - Itsuka Kotori
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --procedure
    DateALive.Lv3Procedure(c,id,CODE_EFREET)
end
s.listed_series={SET_DAL,SET_SPIRIT}
s.listed_names={CODE_SPACEQUAKE,CODE_EFREET}
Duel.LoadScript("cstudios-utility.lua")