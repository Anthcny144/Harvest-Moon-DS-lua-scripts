function GetGameInfo()
    local GC = memory.readdword(0x23FFE0C)
    local REV = memory.readbyte(0x23FFE1E)
    if GC == 0x45434241 and REV == 0 then Game = 1 -- USA 1.0
    elseif GC == 0x45434241 and REV == 1 then Game = 2 -- USA 1.1
    elseif GC == 0x50434241 and REV == 0 then Game = 3 -- EUR 1.0
    elseif GC == 0x50434241 and REV == 1 then Game = 4 -- EUR 1.1
    elseif GC == 0x4A434241 and REV == 0 then Game = 5 -- JPN 1.0
    elseif GC == 0x4A434241 and REV == 2 then Game = 6 -- JPN 1.2
    elseif GC == 0x45344241 and REV == 0 then Game = 7 -- CuteUSA
    elseif GC == 0x4A344241 and REV == 0 then Game = 8 -- CuteJPN
    end
    return Game ~= 0
end