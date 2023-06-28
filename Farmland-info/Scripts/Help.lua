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