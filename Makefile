AUX_DIR   := .aux
OUT_DIR   := outputs
TEX_FILES := $(wildcard figures/*.tex)
PDF_FILES := $(patsubst %.tex,$(OUT_DIR)/%.pdf,$(notdir $(TEX_FILES))) 

LATEXMK  := latexmk

.PHONY: figures clean

figures: $(PDF_FILES)

$(AUX_DIR) $(OUT_DIR):
	@echo "Creating '$@' directory..."
	@mkdir -p $@

$(OUT_DIR)/%.pdf: figures/%.tex | $(AUX_DIR) $(OUT_DIR)
	$(LATEXMK) \
		-interaction=nonstopmode \
		-halt-on-error \
		-auxdir=$(AUX_DIR) \
		-outdir=$(OUT_DIR) \
		$<
		
clean:
	rm -rf $(AUX_DIR) $(OUT_DIR)