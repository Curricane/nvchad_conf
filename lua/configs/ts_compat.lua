-- nvim-treesitter（master 分支，已封版，只保证 Nvim 0.11 兼容）兼容层
--
-- 背景：Nvim 0.12 把 treesitter predicate/directive handler 的 captures 参数从
--   { [capture_id] = TSNode }        -- 0.11
-- 改成了
--   { [capture_id] = TSNode[] }      -- 0.12
-- nvim-treesitter master 里的 handler（#downcase! / #set-lang-from-info-string! /
-- #nth? / #is? / #kind-eq? ...）还是旧写法，于是会把 table 当成 node 传给
-- vim.treesitter.get_node_text()，报：
--   attempt to call method 'range' (a nil value)
-- 触发场景很常见：markdown 里的代码块注入（包括 LSP hover 弹窗的 markdown 高亮）。
--
-- 这里只在“handler 源码来自 nvim-treesitter”时，把 captures 降级成单节点形式；
-- 其它插件（以及 nvim 内置 predicate）不受影响。

local Q = vim.treesitter.query

---@param handler function
---@return boolean
local function from_nvim_treesitter(handler)
  local ok, info = pcall(debug.getinfo, handler, "S")
  local src = ok and info and info.short_src
  return type(src) == "string" and src:find("nvim-treesitter", 1, true) ~= nil
end

--- 0.12 的 { [id] = {node, ...} } -> 0.11 的 { [id] = node }
local function legacy_captures(captures)
  if type(captures) ~= "table" then
    return captures
  end
  local out = {}
  for id, v in pairs(captures) do
    out[id] = type(v) == "table" and v[1] or v
  end
  return out
end

---@param orig function
---@return function
local function with_captures_shim(orig)
  return function(name, handler, opts)
    if type(handler) == "function" and from_nvim_treesitter(handler) then
      local inner = handler
      handler = function(captures, pattern, source, pred, metadata)
        return inner(legacy_captures(captures), pattern, source, pred, metadata)
      end
    end
    return orig(name, handler, opts)
  end
end

Q.add_predicate = with_captures_shim(Q.add_predicate)
Q.add_directive = with_captures_shim(Q.add_directive)
