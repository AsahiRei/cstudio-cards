--DAL Spirit - Efreet
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --spirit effect
    DateALive.SpiritEffectProcedure(c,id,{category=CATEGORY_DEFCHANGE,target=s.deftg,operation=s.defop})
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(1)
	e1:SetCondition(s.econ)
	c:RegisterEffect(e1)
end
s.listed_series={SET_DAL,SET_SPIRIT}
function s.deftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsAttackPos() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAttackPos,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUPDEFENSE)
	local g=Duel.SelectTarget(tp,Card.IsAttackPos,tp,0,LOCATION_MZONE,1,1,nil)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,g,1,tp,0)
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESETS_STANDARD_PHASE_END)
		tc:RegisterEffect(e1)
	end
	if tc:GetDefense()==0 and DateALive.SearchLv3Check(e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,3))
		DateALive.SearchLv3Operation(e,tp)
    end
end
function s.econ(e)
	local tp=e:GetHandlerPlayer()
	return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,SET_DAL),tp,LOCATION_MZONE,0,2,nil)
end
Duel.LoadScript("cstudios-utility.lua")