SHELL := /bin/bash
OTFTOTFM := otftotfm
OTFTOTFMFLAGS :=
OTFTOPFB := cfftot1
OTFINFO := otfinfo
TFMTOPL := tftopl
VFTOVP := vftovp
PLTOTFM := pltotf
VPLTOVF := vptovf
LATEX := latex -interaction nonstopmode -halt-on-error
PDFLATEX := pdflatex -interaction nonstopmode -halt-on-error
PDFTEX := pdftex -interaction nonstopmode -halt-on-error
AWK := awk
SED := sed
RM := rm -rf
MKDIR := mkdir -p
TOUCH := touch
ZIP := zip
INSTALL := install
INSTALLDIR := $(INSTALL) -d
INSTALLDATA := $(INSTALL) -m 644

ifneq (,$(findstring install,$(MAKECMDGOALS)))
TEXMFDIR := $(shell kpsewhich -expand-var='$$TEXMFHOME')
endif

fontname := FSerPro
family := FedraSerifPro
vendor := typotheque
pkg := fedraserif
variants := A B
weights := Book Demi Medium Bold
shapes_up := n sc ssc
shapes_it := n sc ssc sw scsw sscsw
encodings_latin := OT1 T1 LY1 QX T5
encodings_cyr := OT2 T2A T2B T2C X2
encodings := $(encodings_latin) $(encodings_cyr) LGR TS1 OML
variants := A B
figures := LF OsF TLF TOsF

encdir := dvips
tfmdir := tfm
vfdir := vf
auxdir := misc
testdir := test
latexdir := latex
outdirs := $(encdir) $(tfmdir) $(vfdir) $(auxdir) $(testdir)

# create output directories

ifneq ($(MAKECMDGOALS),clean)
create-outdirs := $(shell $(MKDIR) $(outdirs))
endif

texvars := TEXINPUTS=$(latexdir): ENCFONTS=$(encdir): TFMFONTS=$(tfmdir): VFFONTS=$(vfdir):
latex := $(texvars) $(LATEX)
pdflatex := $(texvars) $(PDFLATEX)
pdftex := $(texvars) $(PDFTEX)

flags_basic := --encoding-directory=$(encdir) --tfm-directory=$(tfmdir) --vf-directory=$(vfdir) --pl-directory=$(auxdir) --vpl-directory=$(auxdir) --no-type1 --no-dotlessj --no-updmap --no-map
flags_common := --warn-missing --feature=kern --feature=liga
flags_OsF := --feature=pnum
flags_TOsF := --feature=tnum
flags_LF := --feature=lnum --feature=pnum
flags_TLF := --feature=lnum --feature=tnum
flags_sc := --feature=smcp --unicoding "germandbls =: SSsmall ; dotlessj =: j ; ff =: ; fi =: ; fl =: ; ffi =: ; ffl =: "
flags_ssc := $(flags_sc) --letterspacing=80
flags_sw := --feature=swsh
flags_scsw := $(flags_sc) $(flags_sw)
flags_sscsw := $(flags_ssc) $(flags_sw)
flags_cyr := -scyrl
flags_lgr_common := -sgrek --ligkern "psili_varia {-180} Alpha ; psili_varia {-50} Epsilon ; psili_varia {-50} Eta ; psili_varia {-50} Iota ; psili_varia {-50} Omicron ; psili_varia {-50} Omega ; psili_varia {-180} uni1FBC ; psili_varia {-50} uni1FCC ; psili_varia {-50} uni1FFC ; dasia_varia {-140} Alpha ; dasia_varia {-30} Omicron ; dasia_varia {-30} Omega ; dasia_varia {-140} uni1FBC ; dasia_varia {-30} uni1FFC ; dasia_tonos {-240} Alpha ; dasia_tonos {-50} Epsilon ; dasia_tonos {-50} Eta ; dasia_tonos {-50} Iota ; dasia_tonos {-140} Omicron ; dasia_tonos {-140} Omega ; dasia_tonos {-240} uni1FBC ; dasia_tonos {-50} uni1FCC ; dasia_tonos {-140} uni1FFC ;"
flags_lgr := $(flags_lgr_common) --ligkern "psili {-200} Alpha ; psili {-50} Epsilon ; psili {-50} Eta ; psili {-50} Iota ; psili {-80} Omicron ; psili {-80} Omega ; psili {-200} uni1FBC ; psili {-50} uni1FCC ; psili {-80} uni1FFC ; dasia {-160} Alpha ; dasia {-40} Epsilon ; dasia {-40} Eta ; dasia {-40} Iota ; dasia {-60} Omicron ; dasia {-60} Omega ; dasia {-160} uni1FBC ; dasia {-40} uni1FCC ; dasia {-60} uni1FFC ; psili_tonos {-260} Alpha ; psili_tonos {-50} Epsilon ; psili_tonos {-50} Eta ; psili_tonos {-50} Iota ; psili_tonos {-130} Omicron ; psili_tonos {-130} Omega ; psili_tonos {-260} uni1FBC ; psili_tonos {-50} uni1FCC ; psili_tonos {-130} uni1FFC ; psili_tilde {-280} Alpha ; psili_tilde {-50} Epsilon ; psili_tilde {-50} Eta ; psili_tilde {-50} Iota ; psili_tilde {-160} Omicron ; psili_tilde {-160} Omega ; psili_tilde {-280} uni1FBC ; psili_tilde {-50} uni1FCC ; psili_tilde {-160} uni1FFC ; dasia_tilde {-280} Alpha ; dasia_tilde {-50} Epsilon ; dasia_tilde {-50} Eta ; dasia_tilde {-50} Iota ; dasia_tilde {-160} Omicron ; dasia_tilde {-160} Omega ; dasia_tilde {-280} uni1FBC ; dasia_tilde {-50} uni1FCC ; dasia_tilde {-160} uni1FFC"
flags_lgr_it := $(flags_lgr_common) --ligkern "psili {-150} Alpha ; psili {-150} uni1FBC ; dasia {-110} Alpha ; dasia {-10} Omicron ; dasia {-10} Omega ; dasia {-110} uni1FBC ; dasia {-10} uni1FFC ; psili_tonos {-210} Alpha ; psili_tonos {-80} Omicron ; psili_tonos {-80} Omega ; psili_tonos {-210} uni1FBC ; psili_tonos {-80} uni1FFC ; psili_tilde {-380} Alpha ; psili_tilde {-150} Epsilon ; psili_tilde {-150} Eta ; psili_tilde {-150} Iota ; psili_tilde {-230} Omicron ; psili_tilde {-230} Omega ; psili_tilde {-380} uni1FBC ; psili_tilde {-150} uni1FCC ; psili_tilde {-230} uni1FFC ; dasia_tilde {-380} Alpha ; dasia_tilde {-150} Epsilon ; dasia_tilde {-150} Eta ; dasia_tilde {-150} Iota ; dasia_tilde {-80} Upsilon ; dasia_tilde {-260} Omicron ; dasia_tilde {-260} Omega ; dasia_tilde {-380} uni1FBC ; dasia_tilde {-150} uni1FCC ; dasia_tilde {-260} uni1FFC"
flags_math := --letterspacing=40 --math-spacing

otffiles_in := $(wildcard $(fontname)?-*.otf)
otffiles_up := $(filter $(otffiles_in),$(foreach var,$(variants),$(weights:%=$(fontname)$(var)-%.otf)))
otffiles_it := $(filter $(otffiles_in),$(foreach var,$(variants),$(weights:%=$(fontname)$(var)-%Italic.otf)))
otffiles := $(otffiles_up) $(otffiles_it)
fonts_up := $(foreach file,$(otffiles_up),$(basename $(file)))
fonts_it := $(foreach file,$(otffiles_it),$(basename $(file)))
fonts := $(fonts_up) $(fonts_it)
pfbfiles := $(fonts:%=%.pfb)
suffixes := $(shell $(AWK) -f scripts/print-suffixes.awk glyphlist 2> /dev/null)
glyphlists := $(suffixes:%=.glyphlist-%)
encfiles := $(suffixes:%=$(encdir)/$(pkg)-%.enc)
baselists := $(fonts:%=%.base)
mapfile := $(encdir)/$(pkg).map
plfiles := $(foreach w,$(weights),\
  $(foreach s,A B C E,$(auxdir)/FdSymbol$s-$w.pl))
styfiles := $(addprefix $(latexdir)/,$(pkg).sty $(pkg)-fd.sty mt-$(family).cfg)
fdfiles := $(foreach enc,$(encodings),$(foreach var,$(variants),\
  $(foreach ver,$(figures),$(latexdir)/$(enc)$(family)$(var)-$(ver).fd))) \
  $(foreach var,$(variants),$(latexdir)/U$(family)$(var)-Extra.fd \
  $(latexdir)/U$(family)$(var)-Pi.fd $(latexdir)/U$(family)$(var)-BB.fd)
testfiles := $(foreach var,$(variants),$(latexdir)/test-$(pkg)-$(var).tex)
tempfiles := $(addprefix $(latexdir)/,$(pkg).aux $(pkg).log $(pkg).out $(pkg).toc $(pkg).hd)

# inform about which fonts are being processed

ifneq ($(strip $(otffiles)),)
$(info Processing OTF files: $(otffiles))
else
$(warning No OTF files matching the name $(fontname)A-*.otf or $(fontname)B-*.otf found. Have you copied the fonts into the root directory?)
endif

# auxiliary functions

# $(call shapestr,shape)
shapestr = $(if $(findstring $1,n),,-$1)

# $(call encname,encoding,version)
encname = $(if $(findstring $1,U),$(call lc,$2),$(call lc,$1))

# $(call lc,text)
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))

# macro for building a font table

# $(call fonttable,font)
define fonttable
$(pdftex) -output-dir $(testdir) -jobname $1 \
\\pdfmapfile{=$(mapfile)}\\input fntproof.tex \\init $1 \\table\\bye
endef

# macros for generating font-specific rules

# $(call baserule,font,suffix)
define baserule
.PHONY: $1-baserule
$1-basemetrics: $(auxdir)/$1-Base-$2.pl $(tfmdir)/$1-Base-$2.tfm

$(tfmdir)/$1-Base-$2.tfm: $1.otf $(encdir)/$(pkg)-$2.enc
	$(OTFTOTFM) $(OTFTOTFMFLAGS) $(flags_basic) --literal-encoding=$(encdir)/$(pkg)-$2.enc $1.otf $1-Base-$2

$(auxdir)/$1-Base-$2.pl: $(tfmdir)/$1-Base-$2.tfm
	$(TFMTOPL) $$< $$@
endef

# $(call baserules,font)
define baserules
$(foreach i,$(suffixes),$(eval $(call baserule,$1,$i)))
endef

# $(call fontrule,font,encoding,shape,version,flags)
define fontrule
.PHONY: $1-metrics
$1-metrics: $(tfmdir)/$1-$4$(call shapestr,$3)-$2.tfm $(vfdir)/$1-$4$(call shapestr,$3)-$2.vf

$(tfmdir)/$1-$4$(call shapestr,$3)-$2.tfm $(vfdir)/$1-$4$(call shapestr,$3)-$2.vf: $1.otf enc/$(pkg)-$(call encname,$2,$4).enc $1.base $(suffixes:%=$(tfmdir)/$1-Base-%.tfm)
	$(OTFTOTFM) $(OTFTOTFMFLAGS) $(flags_basic) $(flags_$4) $(flags_$3) $5 --base-encoding=$1.base --encoding=enc/$(pkg)-$(call encname,$2,$4).enc $1.otf $1-$4$(call shapestr,$3)-$2

$(auxdir)/$1-$4$(call shapestr,$3)-$2.vpl: $(vfdir)/$1-$4$(call shapestr,$3)-$2.vf $(tfmdir)/$1-$4$(call shapestr,$3)-$2.tfm $(suffixes:%=$(tfmdir)/$1-Base-%.tfm)
	TFMFONTS=$(tfmdir) $(VFTOVP) $$< > $$@

.PHONY: $1-tables
$1-tables: $(testdir)/$1-$4$(call shapestr,$3)-$2.pdf

$(testdir)/$1-$4$(call shapestr,$3)-$2.pdf: $(tfmdir)/$1-$4$(call shapestr,$3)-$2.tfm $(vfdir)/$1-$4$(call shapestr,$3)-$2.vf $1.pfb $(mapfile) $(encfiles)
	$(call fonttable,$1-$4$(call shapestr,$3)-$2)
endef

# $(call fontrules,font,encondigs,shapes,flags)
define fontrules
$(foreach enc,$2,\
  $(foreach shape,$3,\
    $(foreach fig,$(figures),\
      $(eval $(call fontrule,$1,$(enc),$(shape),$(fig),$4)))))
endef

# $(call pirule,font)
define pirule
.PHONY: $1-pifont
ifneq ($(filter $1Italic,$(fonts_it)),)
$1-pifont: $(tfmdir)/$1-Pi-U.tfm $(vfdir)/$1-Pi-U.vf $(auxdir)/$1-Pi-U.vpl
endif

$(auxdir)/$1-Pi-U.vpl: $(auxdir)/$1-Orn-U.vpl $(auxdir)/$1Italic-Orn-U.vpl $(addprefix fontinst/,$(pkg)-orn-up.etx $(pkg)-orn-it.etx $(pkg)-orn.etx makeorn.tex)
	TEXINPUTS=fontinst:misc: $(PDFTEX) -output-dir $(auxdir) \
	\\input makeorn \\installorn{$1}\\bye
	$(RM) $(auxdir)/makeorn.log

.PHONY: $1-tables
ifneq ($(filter $1Italic,$(fonts_it)),)
$1-tables: $(testdir)/$1-Pi-U.pdf
endif

$(testdir)/$1-Pi-U.pdf: $(tfmdir)/$1-Pi-U.tfm $(vfdir)/$1-Pi-U.vf $(tfmdir)/$1-Orn-U.tfm $(vfdir)/$1-Orn-U.vf $(tfmdir)/$1Italic-Orn-U.tfm $(vfdir)/$1Italic-Orn-U.vf $1.pfb $1Italic.pfb $(mapfile) $(encfiles)
	$(call fonttable,$1-Pi-U)
endef

# $(call mathrule,font,math_version)
define mathrule
.PHONY: $1-math
ifneq ($(filter $1Italic,$(fonts_it)),)
$1-math: $(tfmdir)/$1$2-TOsF-OML.tfm $(vfdir)/$1$2-TOsF-OML.vf $(auxdir)/$1$2-TOsF-OML.vpl
endif

$(auxdir)/$1$2-TOsF-OML.vpl: $(auxdir)/$1-TOsF-OML.vpl $(auxdir)/$1Italic-TOsF-OML.vpl $(plfiles) $(foreach s,a b c e,fontinst/fdsymbol-$s.etx) $(foreach s,french it mixed up,fontinst/$(pkg)-oml-$s.etx) $(addprefix fontinst/,adjustoml.mtx missing.mtx tie.mtx makeoml.tex macros.tex)
	weight=$$$$(echo $1 | $(SED) 's/.*-\(.*\)/\1/'); \
	TEXINPUTS=fontinst:misc: $(PDFTEX) -output-dir $(auxdir) \
	\\input makeoml \\installoml{$1}{$$$$weight}{$2}\\bye
	$(RM) $(auxdir)/makeoml.log

.PHONY: $1-tables
ifneq ($(filter $1Italic,$(fonts_it)),)
$1-tables: $(testdir)/$1$2-TOsF-OML.pdf
endif

$(testdir)/$1$2-TOsF-OML.pdf: $(tfmdir)/$1$2-TOsF-OML.tfm $(vfdir)/$1$2-TOsF-OML.vf $(tfmdir)/$1-TOsF-OML.tfm $(vfdir)/$1-TOsF-OML.vf $(tfmdir)/$1Italic-TOsF-OML.tfm $(vfdir)/$1Italic-TOsF-OML.vf $1.pfb $1Italic.pfb $(mapfile) $(encfiles)
	$(call fonttable,$1$2-TOsF-OML)
endef

# default rule

.PHONY: all
all: type1 dvips metrics pifonts math latex

# rules for building Type 1 fonts

.PHONY: type1
type1: $(pfbfiles)

%.pfb: %.otf
	$(OTFTOPFB) $< $@

# rules for building map file and encoding files

glyphlist:
	echo -e "/a\n/a.superior\n/orn.01\n/Nbb" > $@

.PHONY: dvips
dvips: $(mapfile) $(encfiles)

$(mapfile): glyphlist $(otffiles)
	$(RM) $@; $(TOUCH) $@
	for font in $(fonts); do \
	  psname=$$($(OTFINFO) -p $$font.otf); \
	  for i in $(suffixes); do \
	    I=$$(echo $$i | tr [:lower:] [:upper:]); \
	    echo "$$font-Base-$$i $$psname \"$(family)$$I ReEncodeFont\" <$(pkg)-$$i.enc <$$font.pfb" >> $@; \
	  done; \
	done

$(glyphlists): glyphlist
	grep '^/' glyphlist | split -a 1 -l 256 - .glyphlist-

$(encfiles): $(encdir)/$(pkg)-%.enc: .glyphlist-%
	echo "% CODINGSCHEME FONTSPECIFIC" > $@
	I=$$(echo $* | tr [:lower:] [:upper:]); \
	echo "/$(family)$$I [" >> $@
	cat $< >> $@
	n=$$(wc -l < $<); \
	for ((k = $$n; k < 256; k++)); do \
	  echo "/.notdef" >> $@; \
	done
	echo "] def" >> $@
	scripts/beautify-enc.sh $@

# rule for building base font lists

$(baselists): %.base: glyphlist
	$(RM) $@; $(TOUCH) $@
	for i in $(suffixes); do \
	  echo "$*-Base-$$i dvips/$(pkg)-$$i.enc" >> $@; \
	done

# rules for building font metrics and font tables

.PHONY: basemetrics
basemetrics: $(fonts:%=%-basemetrics)

.PHONY: metrics
metrics: $(fonts:%=%-metrics)

.PHONY: pifonts
pifonts: $(fonts_up:%=%-pifont)

.PHONY: math
math: $(fonts_up:%=%-math)

.PHONY: tables
tables: $(fonts:%=%-tables)

# Base
$(foreach font,$(fonts),$(eval $(call baserules,$(font))))

# Latin
$(foreach font,$(fonts_up),$(eval $(call fontrules,$(font),$(encodings_latin),$(shapes_up),$(flags_common))))
$(foreach font,$(fonts_it),$(eval $(call fontrules,$(font),$(encodings_latin),$(shapes_it),$(flags_common))))
$(foreach font,$(fonts),$(eval $(call fontrules,$(font),TS1,$(shapes_up),$(flags_common))))

# Cyrillic
$(foreach font,$(fonts),$(eval $(call fontrules,$(font),$(encodings_cyr),$(shapes_up),$(flags_common) $(flags_cyr))))

# Greek
$(foreach font,$(fonts_up),$(eval $(call fontrules,$(font),LGR,n,$(flags_common) $(flags_lgr))))
$(foreach font,$(fonts_it),$(eval $(call fontrules,$(font),LGR,n,$(flags_common) $(flags_lgr_it))))

# Extra encodings
$(foreach font,$(fonts_up),\
  $(foreach ver,Extra Orn BB,\
    $(eval $(call fontrule,$(font),U,n,$(ver),$(flags_common)))))
$(foreach font,$(fonts_it),\
  $(foreach ver,Extra Orn,\
    $(eval $(call fontrule,$(font),U,n,$(ver),$(flags_common)))))
$(foreach font,$(fonts_up),$(eval $(call pirule,$(font))))

# Math
$(foreach font,$(fonts),\
  $(eval $(call fontrule,$(font),OML,n,TOsF,$(flags_math))))
$(foreach font,$(fonts_up),$(eval $(call mathrule,$(font),Mixed)))
$(foreach font,$(fonts_up),$(eval $(call mathrule,$(font),French)))

# rules for building metrics from property lists

$(tfmdir)/%.tfm: $(auxdir)/%.pl
	$(PLTOTFM) $< $@

$(vfdir)/%.vf $(tfmdir)/%.tfm: $(auxdir)/%.vpl
	$(VPLTOVF) $< $(vfdir)/$*.vf $(tfmdir)/$*.tfm

# rules for building property lists for FdSymbol

.PHONY: fdsymbol-metrics
fdsymbol-metrics: $(plfiles)

$(plfiles): $(auxdir)/%.pl:
	$(TFMTOPL) $*.tfm $@

# rules for building the LaTeX package

.PHONY: latex
latex: $(styfiles) $(fdfiles)

$(styfiles) $(fdfiles) $(testfiles): $(latexdir)/$(pkg).ins $(latexdir)/$(pkg).dtx
	$(LATEX) -output-directory $(latexdir) $<

# rules for testing the build

.PHONY: test
test: all $(testfiles)
ifneq ($(filter $(fontname)A-%,$(fonts_up)),)
	@echo "Testing Fedra Serif Pro A with pdflatex..."
	$(pdflatex) -output-directory $(testdir) "\pdfmapfile{$(mapfile)}\input{test-$(pkg)-a}"
else
	@echo "Fedra Serif Pro A not installed."
endif
ifneq ($(filter $(fontname)B-%,$(fonts_up)),)
	@echo "Testing Fedra Serif Pro B with pdflatex..."
	$(pdflatex) -output-directory $(testdir) "\pdfmapfile{$(mapfile)}\input{test-$(pkg)-b}"
else
	@echo "Fedra Serif Pro B not installed."
endif

# rules for rebuilding the documentation

.PHONY: doc
doc: $(latexdir)/$(pkg).pdf

$(latexdir)/$(pkg).pdf: $(latexdir)/$(pkg).dtx $(mapfile)
	$(pdflatex) -output-directory $(latexdir) "\pdfmapfile{+$(mapfile)}\input{$(pkg).dtx}" && \
	(while grep -s 'Rerun to get' $(latexdir)/$(pkg).log; do \
	  $(pdflatex) -output-directory $(latexdir) "\pdfmapfile{+$(mapfile)}\input{$(pkg).dtx}"; \
	done)

# rule for checking whether base fonts are complete

.PHONY: check
check:
	@! ls $(encdir)/a_*.enc > /dev/null 2>&1 || ! echo -e "Found auto-generated encoding files: $$(ls -m $(encdir)/a_*.enc)\nAdd glyphs to glyphlist, remove these files, and remake." 1>&2
	@! ls $(auxdir)/*--base.pl > /dev/null 2>&1 || ! echo "Found auto-generated base metrics: $$(ls -m $(auxdir)/*--base.pl)" 1>&2

# rules for building a TDS zip file

.PHONY: tds
tds: $(pkg).tds.zip

$(pkg).tds.zip:
	$(MAKE) install TEXMFDIR:=tds.tmp
	(cd tds.tmp && $(ZIP) -r - *) > $@
	$(RM) tds.tmp

# rules for (un)installing everything

.PHONY: install
install: all check
	$(INSTALLDIR) $(TEXMFDIR)/fonts/type1/$(vendor)/$(pkg)
	$(INSTALLDATA) $(pfbfiles) $(TEXMFDIR)/fonts/type1/$(vendor)/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/fonts/tfm/$(vendor)/$(pkg)
	$(INSTALLDATA) $(tfmdir)/*.tfm $(TEXMFDIR)/fonts/tfm/$(vendor)/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/fonts/vf/$(vendor)/$(pkg)
	$(INSTALLDATA) $(vfdir)/*.vf $(TEXMFDIR)/fonts/vf/$(vendor)/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/fonts/map/dvips/$(pkg)
	$(INSTALLDATA) $(mapfile) $(TEXMFDIR)/fonts/map/dvips/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/fonts/enc/dvips/$(pkg)
	$(INSTALLDATA) $(encfiles) $(TEXMFDIR)/fonts/enc/dvips/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/tex/latex/$(pkg)
	$(INSTALLDATA) $(styfiles) $(fdfiles) $(TEXMFDIR)/tex/latex/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/doc/latex/$(pkg)
	$(INSTALLDATA) $(latexdir)/$(pkg).pdf $(TEXMFDIR)/doc/latex/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/source/latex/$(pkg)
	$(INSTALLDATA) $(latexdir)/$(pkg).ins $(latexdir)/$(pkg).dtx $(TEXMFDIR)/source/latex/$(pkg)

.PHONY: uninstall
uninstall:
	$(RM) $(TEXMFDIR)/fonts/type1/$(vendor)/$(pkg)
	$(RM) $(TEXMFDIR)/fonts/tfm/$(vendor)/$(pkg)
	$(RM) $(TEXMFDIR)/fonts/vf/$(vendor)/$(pkg)
	$(RM) $(TEXMFDIR)/fonts/map/dvips/$(pkg)
	$(RM) $(TEXMFDIR)/fonts/enc/dvips/$(pkg)
	$(RM) $(TEXMFDIR)/tex/latex/$(pkg)
	$(RM) $(TEXMFDIR)/doc/latex/$(pkg)
	$(RM) $(TEXMFDIR)/source/latex/$(pkg)

# rules for cleaning the source tree

.PHONY: clean
clean:
	$(RM) $(pfbfiles)
	$(RM) $(baselists)
	$(RM) .glyphlist-[a-z]
	$(RM) $(outdirs)
	$(RM) $(styfiles)
	$(RM) $(fdfiles)
	$(RM) $(testfiles)
	$(RM) $(tempfiles)

.PHONY: maintainer-clean
maintainer-clean: clean
	$(RM) glyphlist

# delete files on error

.DELETE_ON_ERROR:
