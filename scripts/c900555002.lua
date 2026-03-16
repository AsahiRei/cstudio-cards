--DAL - Yatogami Tohka
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --procedure
    DateALive.Lv3Procedure(c,id,CODE_PRINCESS)
end
s.listed_series={SET_DAL,SET_SPIRIT}
s.listed_names={CODE_SPACEQUAKE,CODE_PRINCESS}
s.spirit_transformation_code=CODE_PRINCESS

Duel.LoadScript("cstudios-utility.lua")