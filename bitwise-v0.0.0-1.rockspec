package = "bitwise"
version = "v0.0.0-1"
source = {
   url = "git://github.com/kamichidu/lua-bitwise",
   tag = "v0.0.0",
}
description = {
   summary = "Bitwise operation library in pure lua implementation.",
   detailed = "Bitwise operation library in pure lua implementation.",
   homepage = "https://github.com/kamichidu/lua-bitwise",
   license = "MIT"
}
dependencies = {}
build = {
   type = "builtin",
   modules = {
      ['bitwise'] = "lib/bitwise.lua",
      ['bitwise.pl'] = "lib/bitwise/pl.lua"
   }
}
