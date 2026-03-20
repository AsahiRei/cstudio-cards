--DAL Inverse Spirit - Demon Lord
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
    --inverse procedure
    DateALive.InverseSpiritProcedure(c,CODE_PRINCESS,id,{category=CATEGORY_DESTROY,target=s.destg,operation=s.desop})
    DateALive.AffectedByEffectOfSpiritComrade(c)
    --cannot activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(s.aclimit)
	e1:SetCondition(s.actcon)
	c:RegisterEffect(e1)
end
s.listed_names={CODE_PRINCESS}
s.listed_series={SET_SPIRIT,SET_DAL,SET_INVERSESPIRIT}
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsSpellTrap,tp,0,LOCATION_ONFIELD,nil)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsSpellTrap,tp,0,LOCATION_ONFIELD,nil)
	if #g==0 then return end
	local ct=Duel.Destroy(g,REASON_EFFECT)
    if ct>0 then
        local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300*ct)
		e1:SetReset(RESETS_STANDARD)
		e:GetHandler():RegisterEffect(e1)
    end
end
function s.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
function s.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end