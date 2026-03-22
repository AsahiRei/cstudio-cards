--DAL - Shadows in Time
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON+CATEGORY_SET)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.operation)
    c:RegisterEffect(e1)
end
s.listed_series={SET_DAL,SET_SPIRIT}
function s.spiritfilter(c,e,tp)
    return c:IsFaceup() and c:IsSetCard(SET_SPIRIT) and c:IsAbleToDeck()
        and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetCode())
end
function s.spfilter(c,e,tp,code)
    return c:IsSetCard(SET_DAL) and c:IsLevel(3) and c:ListsCode(code)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.setfilter(c)
    return c:IsSetCard(SET_DAL) and c:IsTrap() and c:IsSSetable()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.spiritfilter(chkc,e,tp) end
    if chk==0 then return Duel.IsExistingTarget(s.spiritfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
    local g=Duel.SelectTarget(tp,s.spiritfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if not tc or not tc:IsRelateToEffect(e) then return end
    local code=tc:GetCode()
    if Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)==0 then return end
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,code)
    if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
        if Duel.IsExistingMatchingCard(s.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
            Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
            local sg=Duel.SelectMatchingCard(tp,s.setfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
            local sc=sg:GetFirst()
            if sc then
                Duel.SSet(tp,sc)
                --Can activate this turn
                local e1=Effect.CreateEffect(e:GetHandler())
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
                e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
                e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                sc:RegisterEffect(e1)
            end
        end
    end
end