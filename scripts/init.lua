--date a live archetype
if not DateALive then DateALive = {} end
SET_DAL=0x1182
SET_SPIRIT=0x1183
SET_INVERSESPIRIT=0x1184
CODE_SPACEQUAKE=900555001
--spirits
CODE_PRINCESS=900555003
CODE_EFREET=900555005
CODE_HERMIT=900555007
CODE_NIGHTMARE=900555017
CODE_DIVA=900555029
CODE_BERSERK=900555034
CODE_WITCH=900555037
CODE_RULER=900555039
CODE_ANGEL=900555014
CODE_IRREGULAR_AI=900555047
CODE_IRREGULAR_VIRUS=900555049
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
	e3:SetProperty(EFFECT_FLAG_DELAY)
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
DateALive.ExceptionList={900555035,900555044,CODE_NIGHTMARE,CODE_RULER}
function DateALive.ExceptionBaseFilter(c)
    for _,code in ipairs(DateALive.ExceptionList) do
        if c:IsCode(code) then return false end
    end
    return true
end
function DateALive.SpiritEffectCondition(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
    return rc and rc:IsSetCard(SET_DAL) and DateALive.ExceptionBaseFilter(rc)
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
		--for date alive
		elseif e:GetHandler():IsCode(900555032) then
			Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(900555032,0))
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
function DateALive.InverseSpiritProcedure(c,code,id,table)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(DateALive.InverseSpiritCondition(code))
	e1:SetTarget(DateALive.InverseSpiritTarget(code))
	e1:SetOperation(DateALive.InverseSpiritOperation)
	c:RegisterEffect(e1)
	--effect
	local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
	if table.category then
		e2:SetCategory(table.category)
	end
	if table.property then
		e2:SetProperty(table.property)
	end
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(DateALive.SpiritEffectCondition)
	e2:SetTarget(table.target)
	e2:SetOperation(table.operation)
	c:RegisterEffect(e2)
	--destroy replace
    local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
	e2:SetTarget(DateALive.InverseSpiritReplaceTarget)
	e2:SetOperation(DateALive.InverseSpiritReplaceOperation)
	c:RegisterEffect(e2)
end
function DateALive.InverseSpiritFilter(c,code)
	return c:IsCode(code) and c:IsFaceup() and c:IsAbleToRemoveAsCost()
end
function DateALive.InverseSpiritCondition(code)
	return function(e,c)
		if c==nil then return true end
		if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<=0 then return false end
		return Duel.GetMatchingGroupCount(DateALive.InverseSpiritFilter,c:GetControler(),LOCATION_MZONE,0,nil,code)>0
	end
end
function DateALive.InverseSpiritTarget(code)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		local g=Duel.GetMatchingGroup(DateALive.InverseSpiritFilter,tp,LOCATION_MZONE,0,nil,code)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local rg=g:Select(tp,1,1,nil)
		if #rg==1 then
			rg:KeepAlive()
			e:SetLabelObject(rg)
			return true
		end
		return false
	end
end
function DateALive.InverseSpiritOperation(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end
function DateALive.InverseSpiritReplaceFilter(c,e)
	return c:IsFaceup() and c:IsSetCard(SET_DAL) and c:IsDestructable(e)
end
function DateALive.InverseSpiritReplaceTarget(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsOnField() and c:IsFaceup()
		and Duel.IsExistingMatchingCard(DateALive.InverseSpiritReplaceFilter,tp,LOCATION_MZONE,0,1,c,e) end
	if Duel.SelectEffectYesNo(tp,c,96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,DateALive.InverseSpiritReplaceFilter,tp,LOCATION_MZONE,0,1,1,c,e)
		e:SetLabelObject(g:GetFirst())
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	else return false end
end
function DateALive.InverseSpiritReplaceOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	if not tc then return end
	if tc:IsStatus(STATUS_DESTROY_CONFIRMED) then
		Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
	end
end
