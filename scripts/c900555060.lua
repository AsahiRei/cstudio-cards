--DAL Spirit - Lancelot-Artemisia
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    --Xyz Summon
    Xyz.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,SET_DAL),3,3)
    --negate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_DISABLE)
    e1:SetType(EFFECT_TYPE_QUICK_O)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetCost(Cost.DetachFromSelf(1,1,nil))
    e1:SetTarget(s.negtg)
    e1:SetOperation(s.negop)
    c:RegisterEffect(e1)
    --destroy 1 dal
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,1))
    e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_FREE_CHAIN)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,{id,1})
    e2:SetTarget(s.destg)
    e2:SetOperation(s.desop)
    c:RegisterEffect(e2)
end
s.listed_series={SET_DAL,SET_SPIRIT}
function s.cfilter(c,atk)
    return c:IsFaceup() and c:GetAttack()<atk
end
function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    local atk=e:GetHandler():GetAttack()
    if atk<0 then atk=0 end
    if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,0,LOCATION_MZONE,1,nil,atk) end
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local atk=c:GetAttack()
    if atk<0 then atk=0 end
    local g=Duel.GetMatchingGroup(s.cfilter,tp,0,LOCATION_MZONE,nil,atk)
    for tc in aux.Next(g) do
        --negate effects
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e2)
    end
end
function s.desfilter(c)
    return c:IsSetCard(SET_DAL) and c:IsDestructable()
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.desfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp,s.desfilter,tp,LOCATION_HAND,0,1,1,nil)
    local tc=g:GetFirst()
    if not tc then return end
    if Duel.Destroy(tc,REASON_EFFECT)>0 then
        --Apply global debuff
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetTargetRange(0,LOCATION_MZONE)
        e1:SetValue(-600)
        e1:SetReset(RESET_PHASE+PHASE_END)
        Duel.RegisterEffect(e1,tp)
        local e2=e1:Clone()
        e2:SetCode(EFFECT_UPDATE_DEFENSE)
        Duel.RegisterEffect(e2,tp)
        --If it was a "Spirit-" monster → draw
        if tc:IsSetCard(SET_SPIRIT) and Duel.IsPlayerCanDraw(tp,1) then
            Duel.Draw(tp,1,REASON_EFFECT)
        end
    end
end