AUX_DIR   := .aux
OUT_DIR   := outputs

FIG_FILES:= $(wildcard figures/*.tex)
FIG_PDFS := $(patsubst %.tex,$(OUT_DIR)/%.pdf,$(notdir $(FIG_FILES))) 
FIG_SVGS := $(patsubst %.tex,$(OUT_DIR)/%.svg,$(notdir $(FIG_FILES))) 

# Utilities
LATEXMK  ?= latexmk
PDFCAIRO ?= pdftocairo

.PHONY: figures clean

define check-command
	@command -v $(1) >/dev/null 2>&1 || \
		{ echo "Error: $(1) not found."; exit 1; }
endef


$(AUX_DIR) $(OUT_DIR):
	@echo "Creating '$@' directory..."
	@mkdir -p $@

# ------------------------------------------------------------
# LaTeX figures
# ------------------------------------------------------------

figures: $(FIG_SVGS) | $(FIG_PDFS) $(OUT_DIR)

$(FIG_PDFS): $(OUT_DIR)/%.pdf: figures/%.tex | $(AUX_DIR) $(OUT_DIR)
	$(call check-command,$(LATEXMK))
	$(LATEXMK) \
		-interaction=nonstopmode \
		-halt-on-error \
		-auxdir=$(AUX_DIR) \
		-outdir=$(OUT_DIR) \
		$<

$(FIG_SVGS): $(OUT_DIR)/%.svg: $(OUT_DIR)/%.pdf | $(OUT_DIR)
	$(call check-command,$(PDFCAIRO))
	$(PDFCAIRO) -svg $< $@

clean:
	rm -rf $(AUX_DIR) $(OUT_DIR)