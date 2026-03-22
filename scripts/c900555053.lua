--DAL - Spirits' Defender
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
	--protection
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetCost(s.cost)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(s.handcon)
	c:RegisterEffect(e2)
end
s.listed_series={SET_SPIRIT,SET_DAL}
function s.rmfilter(c)
	return c:IsAbleToRemoveAsCost() and c:IsCode(900555009)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.rmfilter,tp,LOCATION_MZONE|LOCATION_GRAVE|LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,s.rmfilter,tp,LOCATION_MZONE|LOCATION_GRAVE|LOCATION_DECK,0,1,1,nil)
	--shuffle
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e1:SetCountLimit(1)
	e1:SetLabelObject(g)
	e1:SetCondition(s.tdcon)
	e1:SetOperation(s.tdop)
	Duel.RegisterEffect(e1,tp)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function s.handcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(aux.FaceupFilter(Card.IsSetCard,SET_IRREGULARSPIRIT),tp,LOCATION_PZONE,0,nil)>0
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetTargetRange(LOCATION_PZONE,0)
	e1:SetValue(aux.indoval)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,SET_DAL))
	e1:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetTargetRange(LOCATION_PZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,SET_DAL))
	e2:SetValue(aux.tgoval)
	e2:SetReset(RESET_PHASE|PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(0,id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_STANDBY|RESET_SELF_TURN,0,1)
end
function s.tdcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,id)>0 and Duel.GetTurnPlayer()==tp
end
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SendtoDeck(g,tp,SEQ_DECKSHUFFLE,REASON_EFFECT)
end