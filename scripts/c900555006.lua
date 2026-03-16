--DAL - Yoshino
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --procedure
    DateALive.Lv3Procedure(c,id,CODE_HERMIT)
end
s.listed_series={SET_DAL,SET_SPIRIT}
s.listed_names={CODE_SPACEQUAKE,CODE_HERMIT}

Duel.LoadScript("cstudios-utility.lua")