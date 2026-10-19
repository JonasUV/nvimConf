require("gitblame").setup({
  enabled = true,
  message_template = "\t~~ <author> • <summary> • <date> • <<sha>>", -- check the Message template section for more options
  date_format = "%d.%m.%y %H:%M:%S", -- check Date format section for more options
  virtual_text_column = 1, -- check Start virtual text at column section for more options
})
