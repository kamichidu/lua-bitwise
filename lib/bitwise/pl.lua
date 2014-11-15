-- The MIT License (MIT)
--
-- Copyright (c) 2014 kamichidu
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
-- THE SOFTWARE.

-- emulate bitwise operation
-- http://ricilake.blogspot.jp/2007/10/iterating-bits-in-lua.html
local bitwise= {}

-- target: 32bit unsigned integer

-- bit32.btest
function bitwise.btest(...)
    return bitwise.band(...) ~= 0x00000000
end

-- bit32.bnot
function bitwise.bnot(x)
    return (-1 - x) % 2 ^ 32
end

-- bit32.band
function bitwise.band(...)
    local x= 0xffffffff
    for _, y in ipairs({...}) do
        x= bitwise._band2(x, y)
    end
    return x
end

-- bit32.bor
function bitwise.bor(...)
    local x= 0x00000000
    for _, y in ipairs({...}) do
        x= bitwise._bor2(x, y)
    end
    return x
end

-- bit32.bxor
function bitwise.bxor(...)
    local x= 0x00000000
    for _, y in ipairs({...}) do
        x= bitwise._bxor2(x, y)
    end
    return x
end

-- bit32.arshift
function bitwise.arshift(x, disp)
end

-- bit32.lshift
function bitwise.lshift(x, disp)
    if disp > 0 then
        return (x * 2 ^ disp) % 2 ^ 32
    elseif disp < 0 then
        return bitwise.rshift(x, -disp)
    else -- disp == 0
        return x
    end
end

-- bit32.rshift
function bitwise.rshift(x, disp)
    if disp > 0 then
        return math.floor(x % 2 ^ 32 / 2 ^ disp)
    elseif disp < 0 then
        return bitwise.lshift(x, disp)
    else -- disp == 0
        return x
    end
end

-- bit32.lrotate
function bitwise.lrotate(x, disp)
    error('Sorry, unimplemented yet.')
end

-- bit32.rrotate
function bitwise.rrotate(x, disp)
    error('Sorry, unimplemented yet.')
end

-- bit32.extract
-- <- higher bit - lower bit ->
-- 31 30 .................. 1 0
function bitwise.extract(n, field, width)
    width= width or 1

    local x= 0x00000000
    local y
    for i= field, field + width - 1 do
        if bitwise._hasbit(n, bitwise._bit(i + 1)) then
            x= bitwise.bor(x, bitwise.lshift(0x00000001, i - field))
        end
    end
    return x
end

-- bit32.replace
function bitwise.replace(n, v, field, width)
    error('Sorry, unimplemented yet.')
end

function bitwise._bxor2(x, y)
    -- x ^ y = (x & ~y) | (~x & y)
    return bitwise.bor(bitwise.band(x, bitwise.bnot(y)), bitwise.band(bitwise.bnot(x), y))
end

function bitwise._band2(x, y)
    local p= 1
    local z= 0
    local limit= x > y and x or y

    while p <= limit do
        if bitwise._hasbit(x, p) and bitwise._hasbit(y, p) then
            z= z + p
        end
        p= p + p
    end

    return z
end

function bitwise._bor2(x, y)
    local p= 1

    while p < x do
        p= p + p
    end
    while p < y do
        p= p + p
    end

    local z= 0

    repeat
        if p <= x or p <= y then
            z= z + p
            if p <= x then
                x= x - p
            end
            if p <= y then
                y= y - p
            end
        end
        p= p * 0.5
    until p < 1

    return z
end

function bitwise._bit(x)
    return 2 ^ (x - 1)
end

function bitwise._hasbit(x, y)
    return x % (y + y) >= y
end

return bitwise
