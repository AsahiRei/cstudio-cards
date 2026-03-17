--DAL - Gabriel Army-Breaking Songstress
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local b1=Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,SET_DAL),tp,LOCATION_MZONE,0,1,nil)
    local b2=Duel.IsExistingMatchingCard(Card.IsDefensePos,tp,0,LOCATION_MZONE,1,nil)
    if chk==0 then return b1 or b2 end
    local op=Duel.SelectEffect(tp,
        {b1,aux.Stringid(id,0)},
        {b2,aux.Stringid(id,1)})
    e:SetLabel(op)
    if op==1 then
        e:SetCategory(CATEGORY_ATKCHANGE)
    else
        e:SetCategory(CATEGORY_POSITION)
        Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
    end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local op=e:GetLabel()
    if op==1 then
        local g=Duel.GetMatchingGroup(aux.FaceupFilter(Card.IsSetCard,SET_DAL),tp,LOCATION_MZONE,0,nil)
        for tc in aux.Next(g) do
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(200*g:GetCount())
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
        end
        local oppg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
        for tc in aux.Next(oppg) do
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(-500)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            tc:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_UPDATE_DEFENSE)
            tc:RegisterEffect(e2)
        end
    elseif op==2 then
        local g=Duel.GetMatchingGroup(Card.IsDefensePos,tp,0,LOCATION_MZONE,nil)
        Duel.ChangePosition(g,0,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)
    end
end