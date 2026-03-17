--DAL - Zadkiel - Freezing puppet
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={SET_SPIRIT}
function s.cfilter(c)
	return c:IsSetCard(SET_SPIRIT) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(aux.FaceupFilter(aux.TRUE),tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local flag=false
	if tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local g=Duel.GetMatchingGroup(aux.FaceupFilter(aux.TRUE),tp,0,LOCATION_MZONE,nil)
		for sc in aux.Next(g) do
			if not sc:IsImmuneToEffect(e) then
				local old_atk=sc:GetAttack()
        		local old_def=sc:GetDefense()
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_UPDATE_ATTACK)
				e1:SetValue(-atk)
				e1:SetReset(RESETS_STANDARD_PHASE_END)
				sc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_UPDATE_DEFENSE)
				e2:SetValue(-def)
				e2:SetReset(RESETS_STANDARD_PHASE_END)
				sc:RegisterEffect(e2)
				Duel.AdjustInstantly(sc)
				if sc:GetAttack()<old_atk or sc:GetDefense()<old_def then
					flag=true
				end
			end
		end
		if flag then
			--gains effect
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(id,2))
			e1:SetCategory(CATEGORY_ATKCHANGE)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetCode(EVENT_BATTLE_START)
			e1:SetReset(RESETS_STANDARD_PHASE_END)
			e1:SetTarget(s.atktg)
			e1:SetOperation(s.atkop)
			tc:RegisterEffect(e1,true)
		end	
	end
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetHandler():GetBattleTarget()
	if chk==0 then return tc and tc:IsControler(1-tp)
		and tc:GetAttack()>0 and tc:GetDefense()>0 end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetHandler():GetBattleTarget()
	if tc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(0)
		tc:RegisterEffect(e2)
	end
	if tc:GetAttack()==0 and tc:GetDefense()==0 then
		local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
    	e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT|RESETS_STANDARD)
    	tc:RegisterEffect(e1)
    	local e2=Effect.CreateEffect(c)
    	e2:SetType(EFFECT_TYPE_SINGLE)
    	e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT|RESETS_STANDARD)
        tc:RegisterEffect(e2)
	end
end
