--DAL - Eden's Flares
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
    e1:SetCountLimit(1,id)
    e1:SetCondition(s.condition)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    --tohand and todeck
    local e2=DateALive.SpellTrapSpiritEffectProc(c,{target=s.rectg,operation=s.recop,cost=true})
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_TODECK)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetCountLimit(1,{id,1})
	e2:SetDescription(aux.Stringid(id,2))
	c:RegisterEffect(e2)
end
s.listed_series={SET_DAL}
function s.cfilter(c,tp)
    return c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousControler(tp)
        and c:IsSetCard(SET_DAL) and (c:IsReason(REASON_BATTLE) or (c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp))
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.cfilter,1,nil,tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_PHASE+PHASE_END)
    e1:SetCountLimit(1)
    e1:SetOperation(s.desop)
    e1:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e1,tp)
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsSummonType,SUMMON_TYPE_SPECIAL),tp,0,LOCATION_MZONE,nil)
    if #g>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
function s.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsSetCard(SET_DAL) end
    if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,LOCATION_GRAVE,0,2,nil,SET_DAL) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    local g=Duel.SelectTarget(tp,Card.IsSetCard,tp,LOCATION_GRAVE,0,2,2,nil,SET_DAL)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g:GetFirst(),1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g:GetNext(),1,0,0)
end
function s.recop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetTargetCards(e)
    if #g<2 then return end
    local hf=g:GetFirst()
    local df=g:GetNext()
    if Duel.SendtoHand(hf,nil,REASON_EFFECT)>0 then
        Duel.ConfirmCards(1-tp,hf)
        Duel.SendtoDeck(df,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)
    end
end