--DAL - Force Switch
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
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
    return c:IsType(TYPE_XYZ) and not c:IsCode(code)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.spiritfilter(c,e,tp,code)
    return c:IsSetCard(SET_SPIRIT) and not c:IsCode(code)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function s.lv3filter(c,e,tp,code)
    return c:IsSetCard(SET_DAL) and c:IsLevel(3) and not c:IsCode(code)
        and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.getSummonTable()
    return {
        {cond=function(tc) return tc:IsSetCard(SET_SPIRIT) end,loc=LOCATION_DECK|LOCATION_HAND,filter=s.spiritfilter},
        {cond=function(tc) return tc:IsType(TYPE_XYZ) end,loc=LOCATION_EXTRA,filter=s.xyzfilter},
        {cond=function(tc) return true end,loc=LOCATION_DECK|LOCATION_HAND,filter=s.lv3filter}
    }
end
function s.thfilter(c,e,tp)
    if not (c:IsFaceup() and c:IsSetCard(SET_DAL)) then return false end
    local code=c:GetCode()
    for _,data in ipairs(s.getSummonTable()) do
        if data.cond(c) and Duel.IsExistingMatchingCard(
            data.filter,tp,data.loc,0,1,nil,e,tp,code
        ) then
            return true
        end
    end
    return false
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.thfilter(chkc,e,tp)
    end
    if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function s.getSummonData(tc,e,tp)
    local code=tc:GetCode()
    for _,data in ipairs(s.getSummonTable()) do
        if data.cond(tc) then
            local g=Duel.GetMatchingGroup(data.filter,tp,data.loc,0,nil,e,tp,code)
            if #g>0 then
                return data,g
            end
        end
    end
    return nil,nil
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if not (tc and tc:IsRelateToEffect(e)) then return end
    if Duel.SendtoHand(tc,nil,REASON_EFFECT)==0 then return end
    local data,g=s.getSummonData(tc,e,tp)
    if not data then return end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local tg=g:Select(tp,1,1,nil):GetFirst()
    if Duel.SpecialSummonStep(tg,0,tp,tp,false,false,POS_FACEUP) then
        if tg:IsSetCard(SET_SPIRIT) then
            Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,0))
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(500)
            e1:SetReset(RESETS_STANDARD_PHASE_END)
            tg:RegisterEffect(e1)
        elseif tg:IsType(TYPE_XYZ) then
            Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,1))
            c:CancelToGrave()
            Duel.Overlay(tg,c)
        elseif tg:IsLevel(3) then
            Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,2))
            Duel.Recover(tp,700,REASON_EFFECT)
        end
        Duel.SpecialSummonComplete()
    end
end