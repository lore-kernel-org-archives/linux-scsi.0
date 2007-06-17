From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [patch 0/5] m68k 53c700 SCSI
Date: Sun, 17 Jun 2007 14:47:04 +0200
Message-ID: <20070617124704.800461751@mail.of.borg>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1760023AbXFQMwJ@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@SteelEye.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@infradead.org>, Kars de Jong <jongk@linux-m68k.org>, Richard Hirst <rhirst@levanta.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

	Hi James,

These patches add support for m68k to the 53c700 SCSI core and introduce new
drivers for various m68k hardware using this 53c700 SCSI core, to replace the
just removed drivers using the old 53c7xx SCSI core.

  [1] [PATCH] 53c700 scsi: m68k support for the 53c700 SCSI core
  [2] [PATCH] 53c700 scsi: m68k BVME6000 NCR53C710 SCSI
  [3] [PATCH] 53c700 scsi: m68k MVME16x NCR53C710 SCSI
  [4] [PATCH] 53c700 scsi: Amiga 4000T NCR53c710 SCSI
  [5] [PATCH] 53c700 scsi: Amiga Zorro NCR53c710 SCSI

Please apply for 2.6.23. Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
