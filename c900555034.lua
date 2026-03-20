--DAL Spirit - Berserk
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --spirit effect
    DateALive.SpiritEffectProcedure(c,id,{category=CATEGORY_TODECK,target=s.tdtg,operation=s.tdop},false)
	DateALive.AffectedByEffectOfSpiritComrade(c)
	--direct attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DIRECT_ATTACK)
	e1:SetCondition(s.atkcon)
	c:RegisterEffect(e1)
end
s.listed_series={SET_DAL,SET_SPIRIT}
s.listed_names={900555033}
function s.filter(c,tp)
	local p=tp
	if c:GetControler()==tp then p=tp else p=1-tp end
	return Duel.IsPlayerCanDraw(p,1)
end
function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsAbleTodeck() end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,Card.IsAbleToDeck,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,c)
	local tc=g:GetFirst()
	local p=tp
	if tc:GetControler()==tp then p=tp else p=1-tp end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetTargetPlayer(p)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,p,1)
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,SEQ_DECKBOTTOM,REASON_EFFECT)>0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		if tc:GetControler()==tp then p=tp else p=1-tp end
		if Duel.Draw(p,d,REASON_EFFECT) and DateALive.SearchLv3Check(e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
			DateALive.SearchLv3Operation(e,tp)
        end
	end
end
function s.atkcon(e)
	local tp=e:GetHandler():GetControler()
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end