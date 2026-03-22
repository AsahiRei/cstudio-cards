--DAL Spirit - Judgement
--scripted by AsahiRei
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--spirit procedure
	DateALive.SpiritEffectProcedure(c,id,{category=CATEGORY_TOHAND+CATEGORY_SEARCH,target=s.thtg,operation=s.thop,mayuri_judgment=true},false)
	--link summon
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,SET_DAL),2)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,5))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCondition(aux.zptcon(aux.TRUE))
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--protection
	local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetCondition(s.indcon)
    e3:SetValue(1)
    c:RegisterEffect(e3)
    local e4=e3:Clone()
    e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
    c:RegisterEffect(e4)
end
s.listed_series={SET_DAL}
s.listed_names={900555056}
function s.thfilter(c,lg)
	return lg:IsContains(c)
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup()
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,lg)
	if chk==0 then return #lg>0 and #g>0 end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,#g,0,0)
	e:SetLabelObject(g)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local next=false
	if #g>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		local atk=0
		for tc in aux.Next(g) do
			atk=atk+tc:GetAttack()
		end
		if atk>0 then
			Duel.Recover(tp,atk//2,REASON_EFFECT)
		end
		next=true
	end
	if next and DateALive.SearchLv3Check(e,tp) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(id,4))
		DateALive.SearchLv3Operation(e,tp)
	end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	local lg=e:GetHandler():GetLinkedGroup()
	local g=eg:Filter(s.thfilter,nil,lg)
	local atk=0
	for tc in aux.Next(g) do
		atk=atk+tc:GetBaseAttack()
	end
	if atk>0 then
		Duel.Damage(1-tp,atk//2,REASON_EFFECT)
	end
end
function s.indcon(e)
    local lg=e:GetHandler():GetLinkedGroup()
    return lg:IsExists(function(c) return c:IsFaceup() and c:IsSetCard(SET_DAL) end,1,nil)
end