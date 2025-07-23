-- lua/core/clipboard.lua
local os_name = vim.loop.os_uname().sysname
local is_wsl = os.getenv("WSL_DISTRO_NAME") ~= nil

if os_name == "Linux" then
  if is_wsl then
    vim.g.clipboard = {
      name = "WslClipboard",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = [[powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))]],
        ["*"] = [[powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))]],
      },
      cache_enabled = 0,
    }
  else
    if vim.fn.executable("clipboard-provider") then
      vim.g.clipboard = {
        name = "myClipboard",
        copy = {
          ["+"] = "clipboard-provider copy",
          ["*"] = "clipboard-provider copy",
        },
        paste = {
          ["+"] = "clipboard-provider paste",
          ["*"] = "clipboard-provider paste",
        },
      }
    end
  end
end