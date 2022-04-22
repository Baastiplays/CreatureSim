local mathb = import("mathb")
local Grid = import("grid")

local PixelSize = 1 --KEEP AT 2

local function lightLevelToCol(D, LinMode)
    if (type(D) ~= "number") then error("first input needs to be number",2) end
    return D*255
end

local function drawFromArray1D(x, y, T, Grid)
    local P = {}
    local Pit = 0
    P.currLightLevel = nil
    for i,v in ipairs(T) do
        if lightLevelToCol(v,true) == P.currLightLevel then
           if P[Pit][2] == nil then
               P[Pit][2] = 1
           end
           P[Pit][2] = P[Pit][2] + 1

        else
            Pit = Pit + 1 
            P.currLightLevel = lightLevelToCol(v,true)
            P[Pit] = {}
            P[Pit][1] = i
            P[Pit][2] = 1
            P[Pit].col = P.currLightLevel
        end
    end
    P.currLightLevel = nil
    for i,v in ipairs(P) do
        term.drawPixels(
            (x+v[1])*PixelSize,
            y*PixelSize,
            v.col,
            PixelSize*(v[2]),
            PixelSize
        )
    end
    return P
end

local function drawFromArray2D(x, y, Grid) -- FIX THIS
    local oT = {} 
    for i, v in ipairs(Grid.grid) do
        oT[i] = drawFromArray1D(x-1,y+i-1,v, Grid)
    end
    -- debugLog(oT,"DFA2D")
end

local function f(x)
    return
    x
    -- math.floor((-480*(0.83^(x+3.08)))+271)
end

local function rgb(x)
    return 255^2/x
end

local function setPalette()
    -- for i=0,255 do
    --     term.setPaletteColor(i, colors.packRGB(f(i)/739,f(i)/692,f(i)/1084))
    -- end
    local function fr(x)
        return (-0.140959*(0.984601^(x-127.5)))+1.01949
    end
    local function fg(x)
        return (-0.41188*(0.991979^(x-127.198)))+1.14716
    end
    local function fb(x)
        return 3/4*x/255+1/4
    end
    for i=0,255 do
        term.setPaletteColor(i, colors.packRGB(fr(i),fg(i),fb(i)))
    end
end

local function resetPalette()
    for i=0,15 do
        local r, g, b = term.nativePaletteColor(2^i)
        term.setPaletteColor(2^i, colors.packRGB(r,g,b))
    end
end

return {
    lightLevelToCol = lightLevelToCol,
    PixelSize = PixelSize,
    drawFromArray1D = drawFromArray1D,
    drawFromArray2D = drawFromArray2D,
    resetPalette = resetPalette,
    setPalette = setPalette
}