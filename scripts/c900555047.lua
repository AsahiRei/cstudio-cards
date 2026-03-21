--DAL Irregular Spirit - AI
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --spirit procedure
    DateALive.SpiritEffectProcedure(c,id,{category=CATEGORY_ATKCHANGE,target=s.atktg,operation=s.atkop},false)
    --pendulum summon
	Pendulum.AddProcedure(c)
    --gains LP
    local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,4))
    e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EVENT_PHASE|PHASE_STANDBY)
	e1:SetCountLimit(1)
    e1:SetCondition(s.lpcon)
	e1:SetTarget(s.lptg)
	e1:SetOperation(s.lpop)
	c:RegisterEffect(e1)
    --unaffected by spell
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetRange(LOCATION_PZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,SET_DAL))
	e2:SetValue(s.efilter)
	c:RegisterEffect(e2,tp)
    --unaffected by spell
    local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
end
s.listed_series={SET_DAL}
s.listed_names={900555046}
function s.lpcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
	if chk==0 then return ct>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(300*ct)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,300*ct)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function s.efilter(e,re)
    return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and re:IsSpellEffect()
end
function s.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(SET_DAL)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and s.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function s.dfilter(c)
    return c:IsType(TYPE_MONSTER) and c:IsSetCard(SET_DAL)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
        Duel.ConfirmDecktop(tp,5)
        local g=Duel.GetDecktopGroup(tp,5)
        local sg=g:Filter(s.dfilter,nil)
        local ct=#sg
        if ct>0 then
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(500*ct)
            e1:SetReset(RESETS_STANDARD_PHASE_END)
            tc:RegisterEffect(e1)
        end
        Duel.ShuffleDeck(tp)
	end
	if DateALive.SearchLv3Check(e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,3))
		DateALive.SearchLv3Operation(e,tp)
    end
end
function s.efilter(e,te)
	return te:IsSpellEffect() and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end