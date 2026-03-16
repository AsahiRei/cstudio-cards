--DAL - Sandalphon - Throne of Annihilation
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --activate
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
end
s.listed_series={SET_DAL,SET_SPIRIT}
function s.cfilter(c)
    return c:IsSetCard(SET_SPIRIT) and c:IsFaceup()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    local g=Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESETS_STANDARD_PHASE_END)
		tc:RegisterEffect(e1)
        local op=Duel.SelectEffect(tp,
            {true,aux.Stringid(id,1)},
            {true,aux.Stringid(id,2)})
        if op==1 then
            local e2=Effect.CreateEffect(c)
            e2:SetDescription(aux.Stringid(id,1))
            e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e2:SetCode(EVENT_BATTLE_DESTROYING)
            e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
            e2:SetCondition(s.excon)
            e2:SetOperation(s.exop)
            e2:SetReset(RESETS_STANDARD_PHASE_END)
            tc:RegisterEffect(e2,true)
        elseif op==2 then
            local e3=Effect.CreateEffect(c)
            e3:SetDescription(aux.Stringid(id,2))
            e3:SetProperty(EFFECT_FLAG_CLIENT_HINT)
            e3:SetType(EFFECT_TYPE_SINGLE)
            e3:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
            e3:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
            e3:SetReset(RESETS_STANDARD_PHASE_END)
            tc:RegisterEffect(e3,true)
        end
    end
end
function s.excon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsReason(REASON_BATTLE) and bc:IsMonster()
end
function s.exop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetValue(1)
    e1:SetReset(RESETS_STANDARD_PHASE_END)
	c:RegisterEffect(e1)
end