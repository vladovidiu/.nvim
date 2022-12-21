import({"nvim-autopairs"}, function(modules) 
    local autopairs = modules["nvim-autopairs"]

    autopairs.setup({
        check_ts = true,
    })
end)
