is_logged = false

function log(message)
    if is_logged then
        printh(message, ".tmp/debug_log.txt")
    end
end

function _init() menu_init() end
