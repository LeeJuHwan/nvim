-- 한글 IME 자동 전환
-- ESC 등으로 인서트/터미널 모드를 빠져나오면 입력 소스를 영문(ABC)으로 되돌린다.
-- 의존: im-select (brew tap daipeihust/tap && brew install im-select)

local ENGLISH = "com.apple.keylayout.ABC"

if vim.fn.has("mac") == 0 or vim.fn.executable("im-select") ~= 1 then
	return
end

local function to_english()
	-- 이미 영문이면 호출을 아끼고, 아니면 비동기로 전환 (입력 지연 방지)
	vim.system({ "im-select" }, { text = true }, function(out)
		local cur = vim.trim(out.stdout or "")
		if cur ~= "" and cur ~= ENGLISH then
			vim.system({ "im-select", ENGLISH })
		end
	end)
end

local group = vim.api.nvim_create_augroup("ImeAutoEnglish", { clear = true })

-- 인서트 모드에서 빠져나올 때 (ESC / <C-c> 포함)
vim.api.nvim_create_autocmd("InsertLeave", {
	group = group,
	callback = to_english,
})

-- 터미널 모드에서 빠져나올 때
vim.api.nvim_create_autocmd("TermLeave", {
	group = group,
	callback = to_english,
})

-- nvim 진입 시에도 영문으로 맞춰둔다
vim.api.nvim_create_autocmd("VimEnter", {
	group = group,
	callback = to_english,
})
