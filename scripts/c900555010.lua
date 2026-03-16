--DAL - Metatron-Angel of Extinction
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--banish
	local e2=DateALive.SpellTrapSpiritEffectProc(c,{target=s.rmtg,operation=s.rmop,cost=true})
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetDescription(aux.Stringid(id,1))
	c:RegisterEffect(e2)
end
s.listed_series={SET_SPIRIT,SET_DAL}
function s.cfilter(c,tp)
	return c:IsSetCard(SET_SPIRIT) and c:IsFaceup()
		and Duel.IsExistingMatchingCard(s.thfilter,tp,0,LOCATION_MZONE,1,nil,e,tp,c:GetAttack())
end
function s.thfilter(c,e,tp,atk)
	return c:IsFaceup() and c:IsAttackBelow(atk) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.cfilter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local g=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetFirst():GetLink(),0,0)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(s.thfilter,tp,0,LOCATION_MZONE,nil,e,tp,tc:GetAttack())
		if #g>0 then
			Duel.SendtoHand(g,1-tp,REASON_EFFECT)
		end
	end
end
function s.cfilter2(c)
	return c:IsSetCard(SET_SPIRIT) and c:IsFaceup()
end
function s.rmfilter(c)
	return c:IsMonster() and c:IsAbleToRemove()
end
function s.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter2,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.rmfilter,tp,0,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_GRAVE)
end
function s.rmop(e,tp,eg,ep,ev,re,r,rp,chk)
	local max_ct=Duel.GetMatchingGroupCount(s.cfilter2,tp,LOCATION_MZONE,0,nil)
	if max_ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.rmfilter),tp,0,LOCATION_GRAVE,1,max_ct,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end