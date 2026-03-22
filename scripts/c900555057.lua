--Close Re-encounter
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_SEARCH)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e1:SetCondition(s.condition)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

s.listed_series={SET_DAL,SET_SPIRIT}
function s.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
end
function s.spfilter(c,e,tp)
    return c:IsSetCard(SET_SPIRIT) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.thfilter(c)
    return c:IsSetCard(SET_DAL) and c:IsLevel(3) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
    Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
    if #g>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
        if DateALive.SearchLv3Check(e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
			DateALive.SearchLv3Operation(e,tp)
        end
    end
end