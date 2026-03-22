--DAL Spirit - Sonogami Rio
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --spirit procedure
    DateALive.SpiritEffectProcedure(c,id,{category=CATEGORY_SPECIAL_SUMMON,target=s.sptg,operation=s.spop,
        mayuri_judgment=true,rio_sonogami=true},false)
    --link summon
    Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,SET_DAL),2)
    --Linked "DAL" monsters cannot be targeted
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(s.tg)
    e2:SetValue(aux.tgoval)
    c:RegisterEffect(e2)
end
s.listed_series={SET_DAL}
function s.spfilter(c,e,tp)
    return c:IsSetCard(SET_DAL) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
        Duel.Draw(tp,1,REASON_EFFECT)
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
        e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
        e1:SetTargetRange(1,0)
        e1:SetTarget(function(e,c) return not c:IsSetCard(SET_DAL) end)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
    end
end
function s.tg(e,c)
    return e:GetHandler():GetLinkedGroup():IsContains(c) and c:IsSetCard(SET_DAL)
end
function s.descon(e,tp,eg,ep,ev,re,r,rp)
    return r&REASON_EFFECT~=0
end