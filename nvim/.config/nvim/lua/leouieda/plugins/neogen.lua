-- ================
-- Configure Neogen
-- ================
require('neogen').setup {
    enabled = true,             --if you want to disable Neogen
    input_after_comment = true, -- (default: true) automatic jump (with insert mode) on inserted annotation
    languages = {
        python = {
            template = {
                annotation_convention = "numpydoc"
            }
        }
    }
}
