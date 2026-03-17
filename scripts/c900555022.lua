--DAL - Force Switch
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
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
end
s.listed_series={SET_DAL,SET_SPIRIT}
function s.xyzfilter(c,e,tp,code)
	return c:IsType(TYPE_XYZ) and not c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spiritfilter(c,e,tp,code)
	return c:IsSetCard(SET_SPIRIT) and not c:IsCode(code)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.spfilterlv3(c,e,tp,code)
	return c:IsSetCard(SET_DAL) and not c:IsCode(code) and c:IsLevel(3)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thfilter(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(SET_DAL)
		and (c:IsSetCard(SET_SPIRIT) and Duel.IsExistingMatchingCard(s.spiritfilter,tp,LOCATION_DECK|LOCATION_HAND,0,1,nil,e,tp,c:GetCode()))
		or (c:IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetCode()))
		or Duel.IsExistingMatchingCard(s.spfilterlv3,tp,LOCATION_DECK|LOCATION_HAND,0,1,nil,e,tp,c:GetCode())
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.thfilter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SendtoHand(tc,nil,REASON_EFFECT)>0 then
			local loc=0
			local filter=nil
			if tc:IsSetCard(SET_SPIRIT) then
				loc=LOCATION_DECK|LOCATION_HAND
				filter=s.spiritfilter
			elseif tc:IsType(TYPE_XYZ) then
				loc=LOCATION_EXTRA
				filter=s.xyzfilter
			else
				loc=LOCATION_DECK|LOCATION_HAND
				filter=s.spfilterlv3
			end
			local g=Duel.GetMatchingGroup(filter,tp,loc,0,nil,e,tp,tc:GetCode())
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end