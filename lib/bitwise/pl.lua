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

function bitwise.bit(x)
    return 2 ^ (x - 1)
end

function bitwise.hasbit(x, y)
    return x % (y + y) >= y
end

function bitwise.bnot(x)
    return (-1 - x) % 2 ^ 32
end

function bitwise.band(...)
    local args= {...}
    local z= 0xffffffff

    for i, arg in ipairs(args) do
        z= bitwise.band2(z, arg)
    end

    return z
end

function bitwise.band2(x, y)
    local p= 1
    local z= 0
    local limit= x > y and x or y

    while p <= limit do
        if bitwise.hasbit(x, p) and bitwise.hasbit(y, p) then
            z= z + p
        end
        p= p + p
    end

    return z
end

function bitwise.bor(...)
    local args= {...}
    local z= 0x00000000

    for i, arg in ipairs(args) do
        z= bitwise.bor2(z, arg)
    end

    return z
end

function bitwise.bor2(x, y)
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

function bitwise.lshift(x, disp)
    if disp == 0 then
        return x
    end

    assert(disp > 0, 'cannot emulate 0 or negative disp')

    return x * 2 ^ disp % 2 ^ 32
end

return bitwise
