if GetGameInfo() then

Addr = 
{
    Time = {0x23D6AFC, 0x23D6AF8, 0x23D6A98, 0x23D6A98, 0x2399E24, 0x2399E24, 0x23B9B7C, 0x2399D54},
    FarmlandPTR = {0x21A5460, 0x21A8218, 0x219D604, 0x219D584, 0x21A0824, 0x219EC24, 0x21891F4, 0x21A87E0},
    HeldItem = {0x23D6B14, 0x23D6B10, 0x23D6AB0, 0x23D6AB0, 0x2399E3C, 0x2399E3C, 0x23B9B94, 0x2399D6C}
}
Addr.Time = Addr.Time[Game]
Addr.FarmlandPTR = Addr.FarmlandPTR[Game]
Addr.HeldItem = Addr.HeldItem[Game]

Const = 
{
    Crop =
    {
        {0x01800329, 0x01800229, 0x01000029},
        {0x02000539, 0x02000639, 0x01000739},
        {0x01800A39, 0x01000C39, 0x01000D39}
    },
    Item =
    {
        {0xE6, 0xE5, 0xE3},
        {0xE8, 0xE9, 0xEA},
        {0xED, 0xEF, 0xF0}
    },
    QualityOffset = 0x2000
}

function IsInitialized()
    local Addr = {0x23DE2A8, 0x23DE2A8, 0x23DE248, 0x23DE2A8, 0x23A1500, 0x23A1500, 0x23C13E0, 0x23A14E0}
    local Check, Similar = {0x61E1103, 0x5070516, 0x1E}, 0
    for i = 0, 2 do
        if memory.readdword(Addr[Game] + i * 4) == Check[i + 1] then Similar = Similar + 1 end
    end
    return Similar ~= 3
end

if IsInitialized() then
    Season = math.floor(memory.readdword(Addr.Time) / 1080000 % 4) + 1
    Cancel = false
    if Season == 4 then
        local Popup = input.popup("The script does not work during Winter.\nThe season will shift to Spring.\nContinue?", "yescancel", "question")
        if Popup == "yes" then
            local Time = memory.readdword(Addr.Time)
            Time = Time + 1080000
            memory.writedword(Addr.Time, Time)
            Season = (Season + 1) % 4
        else Cancel = true end
    end

    Modified = 0
    Impossible = 0
    Chunk = 0
    CoverAll = false
    function Apply()
        local Popup = input.popup("Do you want to cover impossible tiles?", "yesno", "question")
        CoverAll = Popup == "yes"
        while true do
            local From = memory.readdword(Addr.FarmlandPTR + Chunk * 8)
            local To = memory.readdword(Addr.FarmlandPTR + 8 + Chunk * 8)
            if IsAddress(From) and IsAddress(To) then
                for j = 0, (To - From) / 4 do
                    local Address = From + j * 4
                    local IsImpossible = memory.readhalfbyte(Address + 3, true) == 0xF
                    if not IsImpossible or CoverAll then
                        if Address == From then memory.writedword(Address, Const.Crop[Season][1] + Const.QualityOffset * Chunk)
                        elseif Address == To - 4 then memory.writedword(Address, Const.Crop[Season][2] + Const.QualityOffset * Chunk)
                        else memory.writedword(Address, Const.Crop[Season][3] + Const.QualityOffset * Chunk) end
                        if IsImpossible then
                            memory.writehalfbyte(Address + 3, 0xF, true)
                            Impossible = Impossible + 1
                        end
                        Modified = Modified + 1
                    elseif memory.readhalfbyte(Address + 3, true) == 0xF then
                        memory.writedword(Address, 0xFFFFFFFF)
                        Impossible = Impossible + 1
                    end
                end
            else break end
            Chunk = Chunk + 1
        end
    end

    Lock = false
    function Read()
        local HeldItem = memory.readword(Addr.HeldItem)
        local Quality = memory.readbyte(Addr.HeldItem + 2)
        for i = 1, 3 do
            if HeldItem == Const.Item[Season][i] and not Lock then
                Lock = true
                local From = memory.readdword(Addr.FarmlandPTR + Quality * 8)
                local To = memory.readdword(Addr.FarmlandPTR + 8 + Quality * 8)
                local SizeX = memory.readbyte(Addr.FarmlandPTR - 2 + Quality * 8) - memory.readbyte(Addr.FarmlandPTR - 4 + Quality * 8)
                local SizeY = memory.readbyte(Addr.FarmlandPTR - 1 + Quality * 8) - memory.readbyte(Addr.FarmlandPTR - 3 + Quality * 8)
                print("Chunk ID: " .. Quality)
                print("Chunk address: " .. Hex(From, 8))
                print("Chunk size: " .. SizeX .. "x" .. SizeY .. " (" .. (To - From) / 4 .. " tiles)")
                print()
            end
        end

        if HeldItem == 0xFFFF then Lock = false end
    end

    if not Cancel then
        Apply()
        print("Game: " .. Title)
        if CoverAll then
            print("Total tiles: " .. Modified .. " (" .. Impossible .. " impossible tiles)")
        else 
            print("Total tiles: " .. Modified .. " (" .. Impossible .. " impossible tiles revived)")
        end
        print("Total chunks: " .. Chunk)
        print()

        emu.registerafter(Read)
    end
else print("Game is not initialized!") end

else print("Wrong game!") end
