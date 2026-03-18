--date a live archetype
if not DateALive then DateALive = {} end
SET_DAL=0x1182
SET_SPIRIT=0x1183
CODE_SPACEQUAKE=900555001
--spirits
CODE_PRINCESS=900555003
CODE_EFREET=900555005
CODE_HERMIT=900555007
CODE_NIGHTMARE=900555017
CODE_DIVA=900555028
CODE_BERSERK=900555034

--manual handling
EFFECT_OF_SPIRIT_COMRADE=900555026

function DateALive.Lv3Procedure(c,id,codename)
    --search
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(DateALive.SearchSpacequakeTarget)
	e1:SetOperation(DateALive.SearchSpacequakeOperation)
	c:RegisterEffect(e1)
    local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
    --special summon
    local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(Cost.SelfTribute)
    e3:SetCondition(DateALive.SpecialSummonSpiritCondition)
	e3:SetTarget(DateALive.SpecialSummonSpiritTarget(codename))
	e3:SetOperation(DateALive.SpecialSummonSpiritOperation(codename))
	c:RegisterEffect(e3)
end
function DateALive.SearchSpacequakeFilter(c)
	return c:IsCode(CODE_SPACEQUAKE) and c:IsAbleToHand()
end
function DateALive.SearchSpacequakeTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(DateALive.SearchSpacequakeFilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function DateALive.SearchSpacequakeOperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,DateALive.SearchSpacequakeFilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function DateALive.SpecialSummonSpiritCondition(e,tp,eg,ep,ev,re,r,rp)
    return ep~=tp
end
function DateALive.SpecialSummonSpiritFilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function DateALive.SpecialSummonSpiritTarget(codename)
    local code=codename
    return function(e,tp,eg,ep,ev,re,r,rp,chk)
        if chk==0 then
            return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
                and Duel.IsExistingMatchingCard(DateALive.SpecialSummonSpiritFilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil,e,tp,code)
        end
        Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
        Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
    end
end
function DateALive.SpecialSummonSpiritOperation(codename)
    local code=codename
    return function(e,tp,eg,ep,ev,re,r,rp)
        if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then
            return
        end
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
        local g=Duel.SelectMatchingCard(tp,DateALive.SpecialSummonSpiritFilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil,e,tp,code)
        if #g>0 then
		    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
        end
    end
end
function DateALive.SpiritEffectProcedure(c,id,table,spec_loc)
	--effect
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
	if table.category then
		e1:SetCategory(table.category)
	end
	if table.property then
		e1:SetProperty(table.property)
	end
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(DateALive.SpiritEffectCondition)
	e1:SetTarget(table.target)
	e1:SetOperation(table.operation)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(DateALive.SpecialSummonLv3Condition)
	e2:SetTarget(DateALive.SpecialSummonLv3Target(spec_loc))
	e2:SetOperation(DateALive.SpecialSummonLv3Operation(spec_loc))
	c:RegisterEffect(e2)
end
function DateALive.SpiritEffectCondition(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
    return rc and rc:IsSetCard(SET_DAL) and not rc:IsCode(CODE_NIGHTMARE)
end
function DateALive.SearchLv3Filter(c)
	return c:IsSetCard(SET_DAL) and c:IsLevel(3) and c:IsAbleToHand()
end
function DateALive.SearchLv3Check(e,tp)
	return Duel.IsExistingMatchingCard(DateALive.SearchLv3Filter,tp,LOCATION_DECK,0,1,nil)
end
function DateALive.SearchLv3Operation(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,DateALive.SearchLv3Filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function DateALive.SpecialSummonLv3Condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT)
end
function DateALive.SpecialSummonLv3Filter(c,e,tp)
	return c:IsSetCard(SET_DAL) and c:IsLevel(3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function DateALive.SpecialSummonLv3Target(spec_loc)
	local check=spec_loc
	local loc=LOCATION_HAND
	if check==true then
		loc=LOCATION_HAND+LOCATION_DECK
	end
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
				and Duel.IsExistingMatchingCard(DateALive.SpecialSummonLv3Filter,tp,loc,0,1,nil,e,tp)
		end
		--for origami
		if e:GetHandler():IsCode(900555014) then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(900555014,2))
		else
			Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
		end
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,loc)
	end
end
function DateALive.SpecialSummonLv3Operation(spec_loc)
	local check=spec_loc
	local loc=LOCATION_HAND
	if check==true then
		loc=LOCATION_HAND+LOCATION_DECK
	end
	return function(e,tp,eg,ep,ev,re,r,rp)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,DateALive.SpecialSummonLv3Filter,tp,loc,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function DateALive.SpellTrapSpiritEffectProc(c,table)
	local eff=Effect.CreateEffect(c)
	eff:SetType(EFFECT_TYPE_QUICK_O)
	eff:SetCode(EVENT_FREE_CHAIN)
	eff:SetRange(LOCATION_GRAVE)
	eff:SetHintTiming(0,TIMING_MAIN_END|TIMING_SUMMON|TIMING_SPSUMMON)
	if table.cost==true then
		eff:SetCost(Cost.SelfBanish)
	end
	eff:SetCondition(aux.exccon)
	eff:SetTarget(table.target)
	eff:SetOperation(table.operation)
	return eff
end
function DateALive.AffectedByEffectOfSpiritComrade(c)
	--cannot be destroyed
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e1:SetCountLimit(1)
	e1:SetCondition(DateALive.IndesCondition)
	e1:SetValue(DateALive.IndesValue)
	c:RegisterEffect(e1)
end
function DateALive.IndesCondition(e,tp,eg,ep,ev,re,r,rp)
    local p=e:GetHandlerPlayer()
    return Duel.IsPlayerAffectedByEffect(p,EFFECT_OF_SPIRIT_COMRADE)
end
function DateALive.IndesValue(e,re,r,rp)
	return (r&REASON_BATTLE)~=0
end