--DAL - Arusu Marina
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --dal procedure
    DateALive.Lv3Procedure(c,id,CODE_IRREGULAR_VIRUS)
    --pendulum summon
	Pendulum.AddProcedure(c)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,2))
    e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_PZONE)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.thtg)
    e1:SetOperation(s.thop)
    c:RegisterEffect(e1)
    --place irregular ai
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,3))
    e2:SetCategory(CATEGORY_DESTROY)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_PZONE)
    e2:SetCondition(s.pzcon)
    e2:SetTarget(s.pztg)
    e2:SetOperation(s.pzop)
    c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
    e3:SetCountLimit(1)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
    --place this card
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,4))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e1:SetCountLimit(1)
    e1:SetCondition(s.pzcon2)
	e1:SetTarget(s.pztg2)
	e1:SetOperation(s.pzop2)
	c:RegisterEffect(e1)
end
s.listed_series={SET_DAL}
s.listed_names={CODE_IRREGULAR_VIRUS,CODE_SPACEQUAKE}
function s.thfilter(c)
	return c:IsSetCard(SET_DAL) and c:IsType(TYPE_TRAP) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function s.pzcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,SET_DAL),tp,LOCATION_MZONE,0,1,nil)
end
function s.pzfilter(c)
	return c:IsCode(CODE_IRREGULAR_VIRUS) and not c:IsForbidden()
end
function s.pztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDestructable()
        and Duel.IsExistingMatchingCard(s.pzfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.pzop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.Destroy(e:GetHandler(),REASON_EFFECT)~=0 then
        local tc=Duel.SelectMatchingCard(tp,s.pzfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil):GetFirst()
        if not tc then return end
        Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
    end
end
function s.spcfilter(c,tp)
	return c:IsSetCard(SET_DAL) and c:IsType(TYPE_TRAP) and not c:IsPublic()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local rg=Duel.GetMatchingGroup(s.spcfilter,tp,LOCATION_HAND,0,nil)
	return #rg>0 and aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,c)
	local rg=Duel.GetMatchingGroup(s.spcfilter,tp,LOCATION_HAND,0,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,1,1,aux.ChkfMMZ(1),1,tp,HINTMSG_CONFIRM,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
	g:DeleteGroup()
end
function s.pzcon2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end
function s.pztg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsForbidden() 
        and Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.pzop2(e,tp,eg,ep,ev,re,r,rp)
    Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
