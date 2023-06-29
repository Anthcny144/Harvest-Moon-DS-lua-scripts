function memory.readhalfbyte(Address, Side)
    if Side then return bit.band(memory.readbyte(Address), 0xF0) / 0x10 end
    return bit.band(memory.readbyte(Address), 0xF)
end

function memory.writehalfbyte(Address, Value, Side)
    local Write = memory.readhalfbyte(Address, not Side)
    if Side then
        Write = Write + bit.band(Value, 0xF) * 0x10
    else
        Write = Write * 0x10 + bit.band(Value, 0xF)
    end
    memory.writebyte(Address, Write)
end

function Hex(Input, Length)
    local Output = string.format("%x", Input)
    local Zeros = ""
    if string.len(Output) < Length then
        for i = 1, Length - string.len(Output), 1 do
            Zeros = "0" .. Zeros
        end
    end
    return string.upper(Zeros .. Output)
end

function IsAddress(Value)
    return Value >= 0x2000000 and Value < 0x2400000
end