Game = 0
Titles = {"USA 1.0", "USA 1.1", "EUR 1.0", "EUR 1.1", "JPN 1.0", "JPN 1.2", "CuteUSA", "CuteJPN"}

if GetGameInfo() then

Addr = 
{
    FarmlandPTR = {0x21A5460, 0x21A8218, 0x219D604, 0x219D584, 0x21A0824, 0x219EC24, 0x21891F4, 0x21A87E0},
    HeldItem = {0x23D6B14, 0x23D6B10, 0x23D6AB0, 0x23D6AB0, 0x2399E3C, 0x2399E3C, 0x23B9B94, 0x2399D6C}
}
Addr.FarmlandPTR = Addr.FarmlandPTR[Game]
Addr.HeldItem = Addr.HeldItem[Game]

Const = 
{
    Crop = {0x01800329, 0x01800229, 0x01000029},
    Item = {0xE6, 0xE5, 0xE3},
    QualityOffset = 0x2000
}

Modified = 0
Chunk = 0
function Apply()
    local Popup = input.popup("Do you want to cover impossible tiles?", "yesno", "question")
    local CoverAll = Popup == "yes"
    print(CoverAll)
    while true do
        local From = memory.readdword(Addr.FarmlandPTR + Chunk * 8)
        local To = memory.readdword(Addr.FarmlandPTR + 8 + Chunk * 8)
        if IsAddress(From) and IsAddress(To) then
            for j = 0, (To - From) / 4 do
                local Address = From + j * 4
                if memory.readdword(Address) ~= 0xFFFFFFFF or CoverAll then 
                    if Address == From then memory.writedword(Address, Const.Crop[1] + Const.QualityOffset * Chunk)
                    elseif Address == To - 4 then memory.writedword(Address, Const.Crop[2] + Const.QualityOffset * Chunk)
                    else memory.writedword(Address, Const.Crop[3] + Const.QualityOffset * Chunk) end
                    Modified = Modified + 1
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
        if HeldItem == Const.Item[i] and not Lock then
            Lock = true
            local From = memory.readdword(Addr.FarmlandPTR + Quality * 8)
            local To = memory.readdword(Addr.FarmlandPTR + 8 + Quality * 8)
            print("Chunk ID: " .. Quality)
            print("Chunk address: " .. Hex(From, 8))
            print("Tiles in this chunk: " .. (To - From) / 4)
            print()
        end
    end

    if HeldItem == 0xFFFF then Lock = false end
end

Apply()
print("Game: " .. Titles[Game])
print("Total tiles: " .. Modified)
print("Total chunks: " .. Chunk)
print()

emu.registerafter(Read)

else print("Wrong game!") end
