--DAL - Mayuri
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --procedure
    DateALive.Lv3Procedure(c,id,CODE_JUDGEMENT)
    --special summon
    local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	c:RegisterEffect(e1)
    --cannot normal summon
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetCode(EFFECT_CANNOT_SUMMON)
    c:RegisterEffect(e2)
end
s.listed_series={SET_DAL,SET_SPIRIT}
s.listed_names={CODE_SPACEQUAKE,CODE_JUDGEMENT}
function s.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(SET_SPIRIT) and c:IsMonster()
end
function s.spcon(e,c)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
	local g=Duel.GetMatchingGroup(s.cfilter,c:GetControler(),LOCATION_MZONE,0,nil)
	local ct=#g
	return ct>=2
end