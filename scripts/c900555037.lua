--DAL Spirit - Witch
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --spirit effect
    DateALive.SpiritEffectProcedure(c,id,{category=CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,target=s.statstg,operation=s.statsop},false)
	DateALive.AffectedByEffectOfSpiritComrade(c)
end
s.listed_series={SET_DAL,SET_SPIRIT}
s.listed_names={900555036}
function s.statstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
end
function s.statsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetBaseAttack())
		e1:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(tc:GetBaseDefense())
		e2:SetReset(RESET_EVENT|RESETS_STANDARD_DISABLE)
		c:RegisterEffect(e2)
	end
end