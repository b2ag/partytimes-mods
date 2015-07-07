--local LayoutHelpers = import('/lua/maui/layouthelpers.lua')
--local Bitmap = import('/lua/maui/bitmap.lua').Bitmap
--local UIUtil = import('/lua/ui/uiutil.lua')
--local Prefs = import('/lua/user/prefs.lua')
--local options = Prefs.GetFromCurrentProfile('options')
--
--local reclaim = {}
--
--function AddReclaim(r)
--    DestroyReclaimLabel(r)
--    reclaim[r.id] = r
--end
--
--function RemoveReclaim(r)
--    DestroyReclaimLabel(r)
--    reclaim[r.id] = nil
--end
--
--local showingReclaim = false
--
--function CreateReclaimLabel(view, r)
--    local label = Bitmap(view)
--    local pos = r.position
--    local position = Vector(pos[1], pos[2], pos[3])
--
--    label.mass = Bitmap(label)
--    label.mass:SetTexture(UIUtil.UIFile('/game/build-ui/icon-mass_bmp.dds'))
--    LayoutHelpers.AtLeftIn(label.mass, label)
--    LayoutHelpers.AtVerticalCenterIn(label.mass, label)
--    label.mass.Height:Set(14)
--    label.mass.Width:Set(14)
--
--    label.text = UIUtil.CreateText(label, math.floor(0.5+r.mass), 10, UIUtil.bodyFont)
--    label.text:SetColor('ffc7ff8f')
--    label.text:SetDropShadow(true)
--    LayoutHelpers.AtLeftIn(label.text, label, 16)
--    LayoutHelpers.AtVerticalCenterIn(label.text, label)
--
--    label:SetNeedsFrameUpdate(false)
--    label:Hide()
--
--    label.OnFrame = function(self, delta)
--        local pos = view:Project(position)
--        LayoutHelpers.AtLeftTopIn(label, view, pos.x - label.Width() / 2, pos.y - label.Height() / 2 + 1)
--    end
--
--    return label
--end
--
--function DestroyReclaimLabel(r)
--    local view = import('/lua/ui/game/worldview.lua').viewLeft
--    local label = view and view.ReclaimLabels[r.id]
--    if label then
--        label:Destroy()
--        view.ReclaimLabels[r.id] = nil
--    end
--end
--
--function GetLabels()
--    local view = import('/lua/ui/game/worldview.lua').viewLeft
--
--    if not view.ReclaimLabels then
--        view.ReclaimLabels = {}
--    end
--
--    for _, r in reclaim do
--        if not view.ReclaimLabels[r.id] then
--            view.ReclaimLabels[r.id] = CreateReclaimLabel(view, r)
--        end
--    end
--
--    return view.ReclaimLabels
--end
--
---- Called from commandgraph.lua:OnCommandGraphShow()
--function ShowReclaim(show)
--    if show and options.gui_show_reclaim then
--        import('/lua/ui/game/gamemain.lua').AddBeatFunction(ShowReclaimBeat)
--    else
--        import('/lua/ui/game/gamemain.lua').RemoveBeatFunction(ShowReclaimBeat)
--        ShowReclaimBeat('Hide')
--    end
--end
--
--local isInitialized = false
--
--function ShowReclaimBeat(action)
--    local keydown
--
--	if not isInitialized then
--		A9Start()
--		isInitialized = true
--	end
--
--	A9Frame()
--
--    if not action then
--        if options.gui_show_reclaim == 0 then
--            keydown = false
--        else
--            keydown = IsKeyDown('Control')
--        end
--
--        if showingReclaim and not keydown then
--            action = 'Hide'
--        elseif keydown and not showingReclaim then
--            action = 'Show'
--        end
--    end
--
--    if action then
--        local labels = GetLabels()
--        showingReclaim = action == 'Show'
--        for _, l in labels do
--            l[action](l)
--            l:SetNeedsFrameUpdate(showingReclaim)
--        end
--    end
--end
--
--
--local cellW = 0
--local cellH = 0
--local cellN = 60
--local cells = {}
--
--function A9Start()
--	local wv = import('/lua/ui/game/borders.lua').controls.mapGroupLeft;
--	cellW = wv.Width() / cellN
--	cellH = wv.Height() / cellN
--	for x = 0, cellN -1 do
--		cells[x] = {}
--		for y = 0, cellN -1 do
--			local b = Bitmap(wv, 1)
--			--b:SetAlpha(0.5, true)
--			--b:SetSolidColor('ffff0000')
--			b.Left:Set(cellW * x)
--			b.Top:Set(cellH * y)
--			b.Width:Set(cellW)
--			b.Height:Set(cellH)
--			cells[x][y] = {
--				value = 0,
--				element = b
--			}
--		end
--	end
--	
--
--end
--
--function A9Frame()
--    local view = import('/lua/ui/game/worldview.lua').viewLeft
--
--	for x = 0, cellN -1 do
--		for y = 0, cellN -1 do
--			local cell = cells[x][y]
--			cell.value = 0
--			cell.percent = 0
--		end
--	end
--
----{
----INFO:   id="804264151",
----INFO:   mass=45.359996795654,
----INFO:   position={ 144.5, 122.48828125, 126.5 }
----INFO: }
--
--	local total = 0
--	for k,v in reclaim do
--		local p1 = v.position
--		local p2 = Vector(p1[1], p1[2], p1[3])
--		local p3 = view:Project(p2)
--
--		local x = math.floor(p3.x / cellW);
--		local y = math.floor(p3.y / cellH);
--		if x > 0 and y > 0 and x < cellN and y < cellN then
--			local cell = cells[x][y]
--			cell.value = cell.value + v.mass
--			total = total + v.mass
--		end
--
--	end
--
--	if total > 0 then
--		for x = 0, cellN -1 do
--			for y = 0, cellN -1 do
--				local cell = cells[x][y]
--				cell.percent = cell.value / total
--			end
--		end
--	end
--
--	for x = 0, cellN -1 do
--		for y = 0, cellN -1 do
--			local cell = cells[x][y]
--			local colour = percentToColour(cell.percent)
--			cell.element:SetSolidColor(colour)
--			LOG(x,y,colour)
--		end
--	end
--
--end
--
--function percentToColour(p)
--	if p < 0.0001 then return ('00ff0000') end
--	if p < 0.01 then return ('22ff0000') end
--	if p < 0.10 then return ('66ff0000') end
--	if p < 0.20 then return ('77ff0000') end
--	if p < 0.30 then return ('88ff0000') end
--	if p < 0.40 then return ('99ff0000') end
--	if p < 0.50 then return ('aaff0000') end
--	if p < 0.60 then return ('bbff0000') end
--	if p < 0.70 then return ('ccff0000') end
--	if p < 0.80 then return ('ddff0000') end
--	if p < 0.90 then return ('eeff0000') end
--	return ('ffff0000') 
--end
