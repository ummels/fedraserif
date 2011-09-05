SHELL := /bin/sh
OTFTOTFM := otftotfm
OTFTOTFMFLAGS :=
OTFTOPFB := cfftot1
OTFINFO := otfinfo
TFMTOPL := tftopl
PLTOTFM := pltotf
VPLTOVF := vptovf
PDFTEX := pdftex -interaction nonstopmode -halt-on-error
PDFLATEX := pdflatex -interaction nonstopmode -halt-on-error
AWK := awk
SED := sed
RM := rm -rf
MKDIR := mkdir -p
TOUCH := touch
INSTALL := install
INSTALLDIR := $(INSTALL) -d
INSTALLDATA := $(INSTALL) -m 644

DVIPSDIR := dvips
TFMDIR := tfm
VFDIR := vf
AUXDIR := misc
TESTDIR := test

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
encodings := OT1 T1 TS1 LY1 QX
figures := LF OsF TLF TOsF

flags_basic := --pl --encoding-directory=$(DVIPSDIR) --tfm-directory=$(TFMDIR) --vf-directory=$(VFDIR) --pl-directory=$(AUXDIR) --vpl-directory=$(AUXDIR) --no-type1 --no-dotlessj --no-updmap --no-map
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
encfiles := $(suffixes:%=$(DVIPSDIR)/$(pkg)-%.enc) 
baselists := $(fonts:%=%.base)
mapfile := $(DVIPSDIR)/$(pkg).map
plfiles := $(foreach w,Book Regular Medium Bold,\
  $(foreach s,A B C E,$(AUXDIR)/FdSymbol$s-$w.pl))
styfiles := $(addprefix latex/,$(pkg).sty $(pkg)-fd.sty mt-$(family).cfg)
fdfiles := $(foreach enc,$(encodings) OML,\
  $(foreach ver,$(figures),latex/$(enc)$(family)-$(ver).fd)) \
  latex/U$(family)-Extra.fd latex/U$(family)-Pi.fd \
  latex/U$(family)-BB.fd
tempfiles := $(addprefix latex/,$(pkg).aux $(pkg).log $(pkg).out $(pkg).toc)
outdirs := $(DVIPSDIR) $(TFMDIR) $(VFDIR) $(AUXDIR) $(TESTDIR)

# create output directories

ifeq (,$(findstring clean,$(MAKECMDGOALS)))
create-dirs := $(shell $(MKDIR) $(outdirs))
endif

# auxilary functions

# $(call shapestr,shape)
shapestr = $(if $(findstring $1,n),,-$1)

# $(call encname,encoding,version)
encname = $(if $(findstring $1,U),$(call lc,$2),$(call lc,$1))

# $(call lc,text)
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))

# macro for building a font table

# $(call fonttable,font)
define fonttable
TEXFONTS=$(TFMDIR):$(VFDIR): ENCFONTS=$(DVIPSDIR): \
$(PDFTEX) -output-dir $(TESTDIR) -jobname $1 \
\\pdfmapfile{=$(mapfile)}\\input fntproof.tex \\init $1 \\table\\bye
endef

# macros for generating font-specific rules

# $(call baserule,font,suffix)
define baserule
.PHONY: $1-basemetrics
$1-basemetrics: $(AUXDIR)/$1-Base-$2.pl $(TFMDIR)/$1-Base-$2.tfm
$(AUXDIR)/$1-Base-$2.pl: $1.otf $(DVIPSDIR)/$(pkg)-$2.enc
	$(OTFTOTFM) $(OTFTOTFMFLAGS) $(flags_basic) --literal-encoding=$(DVIPSDIR)/$(pkg)-$2.enc $1.otf $1-Base-$2
endef

# $(call baserules,font)
define baserules
$(foreach i,$(suffixes),$(eval $(call baserule,$1,$i)))
endef

# $(call fontrule,font,encoding,shape,version,flags)
define fontrule
.PHONY: $1-metrics
$1-metrics: $(TFMDIR)/$1-$4$(call shapestr,$3)-$2.tfm $(VFDIR)/$1-$4$(call shapestr,$3)-$2.vf $(AUXDIR)/$1-$4$(call shapestr,$3)-$2.vpl
$(AUXDIR)/$1-$4$(call shapestr,$3)-$2.vpl: $1.otf enc/$(pkg)-$(call encname,$2,$4).enc $1.base $(suffixes:%=$(TFMDIR)/$1-Base-%.tfm)
	$(OTFTOTFM) $(OTFTOTFMFLAGS) $(flags_basic) $(flags_$4) $(flags_$3) $5 --base-encoding=$1.base --encoding=enc/$(pkg)-$(call encname,$2,$4).enc $1.otf $1-$4$(call shapestr,$3)-$2
	$(TOUCH) $$@

.PHONY: $1-tables
$1-tables: $(TESTDIR)/$1-$4$(call shapestr,$3)-$2.pdf
$(TESTDIR)/$1-$4$(call shapestr,$3)-$2.pdf: $(TFMDIR)/$1-$4$(call shapestr,$3)-$2.tfm $(VFDIR)/$1-$4$(call shapestr,$3)-$2.vf $1.pfb $(mapfile) $(encfiles)
	$(call fonttable,$1-$4$(call shapestr,$3)-$2)
endef

# $(call fontrules,font,shapes)
define fontrules
# regular encodings
$(foreach enc,$(encodings),\
  $(foreach shape,$2,\
    $(foreach fig,$(figures),\
      $(eval $(call fontrule,$1,$(enc),$(shape),$(fig),$(flags_common))))))
# OML encoding
$(eval $(call fontrule,$1,OML,n,TOsF,$(flags_math)))
# extra encodings
$(foreach ver,Extra Orn BB,\
  $(eval $(call fontrule,$1,U,n,$(ver),$(flags_common))))
endef

# $(call pirule,font)
define pirule
.PHONY: $1-virtual
$1-virtual: $(TFMDIR)/$1-Pi-U.tfm $(VFDIR)/$1-Pi-U.vf $(AUXDIR)/$1-Pi-U.vpl
$(AUXDIR)/$1-Pi-U.vpl: $(AUXDIR)/$1-Orn-U.vpl $(AUXDIR)/$1Italic-Orn-U.vpl $(addprefix fontinst/,$(pkg)-orn-up.etx $(pkg)-orn-it.etx $(pkg)-orn.etx makeorn.tex)
	TEXINPUTS=fontinst:misc: $(PDFTEX) -output-dir $(AUXDIR) \
	\\input makeorn \\installorn{$1}\\bye
	$(RM) $(AUXDIR)/makeorn.log

.PHONY: $1-tables
$1-tables: $(TESTDIR)/$1-Pi-U.pdf
$(TESTDIR)/$1-Pi-U.pdf: $(TFMDIR)/$1-Pi-U.tfm $(VFDIR)/$1-Pi-U.vf $(TFMDIR)/$1-Orn-U.tfm $(VFDIR)/$1-Orn-U.vf $(TFMDIR)/$1Italic-Orn-U.tfm $(VFDIR)/$1Italic-Orn-U.vf $1.pfb $1Italic.pfb $(mapfile) $(encfiles)
	$(call fonttable,$1-Pi-U)
endef

# $(call mathrule,font,math_version)
define mathrule
.PHONY: $1-virtual
$1-virtual: $(TFMDIR)/$1$2-TOsF-OML.tfm $(VFDIR)/$1$2-TOsF-OML.vf $(AUXDIR)/$1$2-TOsF-OML.vpl
$(AUXDIR)/$1$2-TOsF-OML.vpl: $(AUXDIR)/$1-TOsF-OML.vpl $(AUXDIR)/$1Italic-TOsF-OML.vpl $(plfiles) $(foreach s,a b c e,fontinst/fdsymbol-$s.etx) $(foreach s,french it mixed up,fontinst/$(pkg)-oml-$s.etx) $(addprefix fontinst/,adjustoml.mtx missing.mtx tie.mtx makeoml.tex macros.tex)
	weight=$$$$(echo $1 | $(SED) 's/.*-\(.*\)/\1/;s/Demi/Regular/'); \
	TEXINPUTS=fontinst:misc: $(PDFTEX) -output-dir $(AUXDIR) \
	\\input makeoml \\installoml{$1}{$$$$weight}{$2}\\bye
	$(RM) $(AUXDIR)/makeoml.log

.PHONY: $1-tables
$1-tables: $(TESTDIR)/$1$2-TOsF-OML.pdf
$(TESTDIR)/$1$2-TOsF-OML.pdf: $(TFMDIR)/$1$2-TOsF-OML.tfm $(VFDIR)/$1$2-TOsF-OML.vf $(TFMDIR)/$1-TOsF-OML.tfm $(VFDIR)/$1-TOsF-OML.vf $(TFMDIR)/$1Italic-TOsF-OML.tfm $(VFDIR)/$1Italic-TOsF-OML.vf $1.pfb $1Italic.pfb $(mapfile) $(encfiles)
	$(call fonttable,$1$2-TOsF-OML)
endef

# default rule

.PHONY: all
all: type1 dvips metrics virtual latex

# rules for building Type 1 fonts

.PHONY: type1
type1: $(pfbfiles)

%.pfb: %.otf
	$(OTFTOPFB) $< $@

# rules for building map file and encoding files

glyphlist:
	$(TOUCH) $@

.PHONY: dvips
dvips: $(mapfile) $(encfiles)

$(mapfile): glyphlist
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

$(encfiles): $(DVIPSDIR)/$(pkg)-%.enc: .glyphlist-%
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

.PHONY: virtual
virtual: $(fonts_up:%=%-virtual)

.PHONY: tables
tables: $(fonts:%=%-tables)

$(foreach font,$(fonts),$(eval $(call baserules,$(font))))
$(foreach font,$(fonts_up),$(eval $(call fontrules,$(font),$(shapes_up))))
$(foreach font,$(fonts_it),$(eval $(call fontrules,$(font),$(shapes_it))))
$(foreach font,$(fonts_up),$(eval $(call pirule,$(font))))
$(foreach font,$(fonts_up),$(eval $(call mathrule,$(font),Mixed)))
$(foreach font,$(fonts_up),$(eval $(call mathrule,$(font),French)))

# rules for building metrics from property lists

$(TFMDIR)/%.tfm: $(AUXDIR)/%.pl
	$(PLTOTFM) $< $@

$(VFDIR)/%.vf $(TFMDIR)/%.tfm: $(AUXDIR)/%.vpl
	$(VPLTOVF) $< $(VFDIR)/$*.vf $(TFMDIR)/$*.tfm

# rules for building property lists for FdSymbol

.PHONY: fdsymbol-metrics
fdsymbol-metrics: $(plfiles)

$(plfiles): $(AUXDIR)/%.pl:
	$(TFMTOPL) $*.tfm $@

# rules for building the LaTeX package

.PHONY: latex
latex: $(styfiles) $(fdfiles)

$(styfiles) $(fdfiles): latex/$(pkg).ins latex/$(pkg).dtx
	cd latex && $(PDFLATEX) $(pkg).ins

# rules for rebuilding the documentation

.PHONY: doc
doc: latex/$(pkg).pdf

latex/$(pkg).pdf: latex/$(pkg).dtx
	cd latex && $(PDFLATEX) $(pkg).dtx && \
	(while grep -s 'Rerun to get' $(pkg).log; do \
	  $(PDFLATEX) $(pkg).dtx; \
	done)

# rule for checking whether base fonts are complete

.PHONY: check
check:
	@! ls $(DVIPSDIR)/a_*.enc > /dev/null 2>&1 || ! echo "Found auto-generated encoding files: $$(ls -m $(DVIPSDIR)/a_*.enc)\nAdd glyphs to glyphlist, remove these files, and remake." 1>&2
	@! ls $(AUXDIR)/*--base.pl > /dev/null 2>&1 || ! echo "Found auto-generated base metrics: $$(ls -m $(AUXDIR)/*--base.pl)" 1>&2

# rules for (un)installing everything

.PHONY: install
install: all check
	$(INSTALLDIR) $(TEXMFDIR)/fonts/type1/$(vendor)/$(pkg)
	$(INSTALLDATA) $(pfbfiles) $(TEXMFDIR)/fonts/type1/$(vendor)/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/fonts/tfm/$(vendor)/$(pkg)
	$(INSTALLDATA) $(TFMDIR)/*.tfm $(TEXMFDIR)/fonts/tfm/$(vendor)/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/fonts/vf/$(vendor)/$(pkg)
	$(INSTALLDATA) $(VFDIR)/*.vf $(TEXMFDIR)/fonts/vf/$(vendor)/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/fonts/map/dvips/$(pkg)
	$(INSTALLDATA) $(mapfile) $(TEXMFDIR)/fonts/map/dvips/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/fonts/enc/dvips/$(pkg)
	$(INSTALLDATA) $(encfiles) $(TEXMFDIR)/fonts/enc/dvips/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/tex/latex/$(pkg)
	$(INSTALLDATA) $(styfiles) $(fdfiles) $(TEXMFDIR)/tex/latex/$(pkg)
	$(INSTALLDIR) $(TEXMFDIR)/doc/latex/$(pkg)
	$(INSTALLDATA) latex/$(pkg).pdf $(TEXMFDIR)/doc/latex/$(pkg)

.PHONY: uninstall
uninstall:
	$(RM) $(TEXMFDIR)/fonts/type1/$(vendor)/$(pkg)
	$(RM) $(TEXMFDIR)/fonts/tfm/$(vendor)/$(pkg)
	$(RM) $(TEXMFDIR)/fonts/vf/$(vendor)/$(pkg)
	$(RM) $(TEXMFDIR)/fonts/map/dvips/$(pkg)
	$(RM) $(TEXMFDIR)/fonts/enc/dvips/$(pkg)
	$(RM) $(TEXMFDIR)/tex/latex/$(pkg)
	$(RM) $(TEXMFDIR)/doc/latex/$(pkg)

# rules for cleaning the source tree

.PHONY: clean
clean:
	$(RM) $(pfbfiles)
	$(RM) $(baselists)
	$(RM) .glyphlist-[a-z]
	$(RM) $(outdirs)
	$(RM) $(styfiles)
	$(RM) $(fdfiles)
	$(RM) $(tempfiles)

.PHONY: maintainer-clean
maintainer-clean: clean
	$(RM) glyphlist

# delete files on error

.DELETE_ON_ERROR:
