--DAL Spirit - Sister
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
    --spirit effect
    DateALive.SpiritEffectProcedure(c,id,{category=CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE,target=s.statstg,operation=s.statsop},false)
	DateALive.AffectedByEffectOfSpiritComrade(c)
	--gains effect
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,4))
    e1:SetCategory(CATEGORY_RECOVER)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.lptg)
    e1:SetOperation(s.lpop)
    c:RegisterEffect(e1)
end
s.listed_series={SET_DAL,SET_SPIRIT}
s.listed_names={900555050}
function s.statstg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)>=5 end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function s.cfilter(c)
    return c:IsFaceup() and c:IsSetCard(SET_DAL)
end
function s.statsop(e,tp,eg,ep,ev,re,r,rp)
    Duel.ConfirmDecktop(1-tp,5)
    local g=Duel.GetDecktopGroup(1-tp,5)
    if #g==0 then return end
    Duel.ConfirmCards(tp,g)
    local ct=g:FilterCount(Card.IsMonster,nil)
    Duel.ShuffleDeck(1-tp)
    if ct>0 then
        local g2=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,0,nil)
        for tc in aux.Next(g2) do
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_ATTACK)
            e1:SetValue(ct*100)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
            tc:RegisterEffect(e1)
            local e2=e1:Clone()
            e2:SetCode(EFFECT_UPDATE_DEFENSE)
            tc:RegisterEffect(e2)
        end
    end
    if DateALive.SearchLv3Check(e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,3))
		DateALive.SearchLv3Operation(e,tp)
    end
end
function s.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local diff=math.abs(Duel.GetLP(tp)-Duel.GetLP(1-tp))
    if chk==0 then return diff>0 end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
    Duel.SetTargetPlayer(tp)
    Duel.SetTargetParam(diff)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,diff)
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
    local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
    Duel.Recover(p,d,REASON_EFFECT)
end