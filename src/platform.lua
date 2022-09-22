function engine.platform.dll_extension()
  if jit.os == "Windows" then return "dll"   end
  if jit.os == "Linux"   then return "so"    end
  if jit.os == "OSX"     then return "dylib" end
end
