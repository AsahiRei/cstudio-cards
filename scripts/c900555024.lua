--DAL - Rasiel - Tome of Revelation
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={SET_DAL}
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)>0  end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.rmfilter(c,e,tp,eg,ep,ev,re,r,rp)
	if c:IsCode(id) then return false end
	if not c:IsType(TYPE_SPELL) or not c:IsSetCard(SET_DAL) or not c:IsAbleToRemove() then return false end
	local te=c:GetActivateEffect()
	local tg=te:GetTarget()
	if tg then return tg(e,tp,eg,ep,ev,re,r,rp,0) end
	return true
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if #g>0 then
		local tc=g:RandomSelect(tp,1):GetFirst()
		Duel.ConfirmCards(tp,tc)
		--cannot special summon
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(id,1))
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
		e1:SetTargetRange(0,1)
		e1:SetTarget(s.splimit)
		e1:SetLabel(tc:GetType())
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
	if Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp,eg,ep,ev,re,r,rp)
		and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,3))
		Duel.BreakEffect()
		local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local tc=g:GetFirst()
		local te=tc:GetActivateEffect()
		local op=te:GetOperation()
		local tg=te:GetTarget()
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function s.splimit(e,c)
	local typ=e:GetLabel()
	return c:IsLocation(LOCATION_EXTRA) and c:GetType()==typ
end