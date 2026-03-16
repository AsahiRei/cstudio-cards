--DAL - Yatogami Tohka
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --procedure
    DateALive.Lv3Procedure(c,id,CODE_NIGHTMARE)
end
s.listed_series={SET_DAL,CODE_NIGHTMARE}
s.listed_names={CODE_SPACEQUAKE,CODE_NIGHTMARE}

Duel.LoadScript("cstudios-utility.lua")