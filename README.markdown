fedraserif - LaTeX support for Fedra Serif Pro
==============================================

The fedraserif package provides LaTeX support for the (commercial)
Fedra Serif Pro font family by [Typotheque][TT].

[TT]: http://www.typotheque.com/fonts/

Usage
-----

To use this package with Fedra Serif A as the main text font, include

    \usepackage{fedraserif}

in the preamble of your LaTeX document. To use Fedra Serif B as the main
text font, use the command

    \usepackage[variant=B]{fedraserif}

instead. See the [PDF documentation](latex/fedraserif.pdf) for the details.

If you get errors about insufficient memory, you might need to
increase the values of `font_mem_size` and `font_max` in your TeX
configuration. For most distributions, these can be changed in the
file texmf.cnf. For MiKTeX, the file is called miktex.ini.

Installation
------------

Building the font metrics requires the [LCDF typetools][LCDF] in version 2.90
or higher, as distributed with TeXLive 2011. Building the math font
requires additionally that the TFM files for [fdsymbol] are installed on your
system (in a directory that is searched by TeX for TFM files).

[LCDF]: http://www.lcdf.org/type/
[fdsymbol]: https://www.github.com/ummels/fdsymbol

Before starting the installation, you need to copy the original OpenType Pro
font files as obtained from Typotheque into the root directory of the sources
(the directory in which e.g. the file Makefile resides). In order for the
package to be usable, you will need at least the files FSerProA-Book.otf and
FSerProA-BookItalic.otf or the files FSerProB-Book.otf and
FSerProB-BookItalic.otf.

To install the fonts, the TeX font metrics, the LaTeX package and the
documentation in your home texmf tree, run:

    make install

If you want to use a different texmf tree, you can specify it using the
variable TEXMFDIR:

    make install TEXMFDIR=/usr/local/texlive/texmf-local

Afterwards, you may need to regenerate the file database:

    texhash

Finally, you need to activate the map file:

    updmap --enable Map=fedraserif.map

For a system-wide installation, replace updmap by updmap-sys.

Compatibility
-------------

This package has only been tested with version 3.5 (2012) of Fedra Serif Pro.
Some glyphs might be incorrect or missing when an installation is performed
with an older version of the fonts.
To find out the version of the fonts in your environment, run

    otfinfo -v

on one of the OpenType font files.

License
-------

Copyright (c) 2011-2025 by Michael Ummels <michael@ummels.de>

The LaTeX support files contained in this software may be distributed
and modified under the terms and conditions of the
[LaTeX Project Public License][LPPL], version 1.3c or greater (your choice).

[LPPL]: http://www.latex-project.org/lppl/

This work has the LPPL maintenance status `maintained'.

The Current Maintainer of this work is Michael Ummels.

This work consists of the files fedraserif.dtx, fedraserif.ins and
the derived files listed in fedraserif.ins as well as the
documentation file fedraserif.pdf.

All other files distributed with these sources are in the public domain.

Fedra(R) is a registered trademark of Typotheque VOF.
