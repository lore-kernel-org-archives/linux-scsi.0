From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 0/21] m68k/scsi: wd33c93 driver cleanups
Date: Sun,  4 Apr 2010 11:00:30 +0200
Message-ID: <1270371651-2584-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-m68k-owner@vger.kernel.org>
Sender: linux-m68k-owner@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: linux-m68k@lists.linux-m68k.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


	Hi all,

Here's a series of easter eggs for the m68k wd33c93 SCSI drivers:
  - [01] scsi: wd33c93 - Kill empty wd33c93_release()
  - [02] m68k/scsi: a2091 - Reindentation
  - [03] m68k/scsi: gvp11 - Reindentation
  - [04] m68k/scsi: mvme147 - Reindentation
  - [05] m68k/scsi: a3000 - Reindentation
  - [06] m68k/scsi: a2091 - Use shost_priv() and kill ugly HDATA() macro
  - [07] m68k/scsi: gvp11 - Use shost_priv() and kill ugly HDATA() macro
  - [08] m68k/scsi: mvme147 - Use shost_priv() and kill ugly HDATA() macro
  - [09] m68k/scsi: a3000 - Use shost_priv() and kill ugly HDATA() macro
  - [10] m68k/scsi: a2091 - Kill ugly DMA() macro
  - [11] m68k/scsi: gvp11 - Kill ugly DMA() macro
  - [12] m68k/scsi: a3000 - Kill ugly DMA() macro
  - [13] m68k/scsi: mvme147 - Kill static global mvme147_host
  - [14] m68k/scsi: a3000 - Kill static global a3000_host
  - [15] m68k/scsi: gvp11 - Extract check_wd33c93()
  - [16] m68k/scsi: a2091 - Kill a2091_scsiregs typedef
  - [17] m68k/scsi: gvp11 - Kill gvp11_scsiregs typedef
  - [18] m68k/scsi: a3000 - Kill a3000_scsiregs typedef
  - [19] m68k/scsi: mvme147 - Kill obsolete HOSTS_C logic
  - [20] m68k: amiga - A2091/A590 SCSI zorro_driver conversion
  - [21] m68k: amiga - GVP Series II SCSI zorro_driver conversion

This series consists of 3 parts:
  - Easter egg 01 is a trivial cleanup for the wd33c93 core,
  - Easter eggs 02-19 do various cleanups for the m68k wd33c93 SCSI drivers,
  - Easter eggs 20 and 21 convert the A2091/A590 and GVP Series II SCSI drivers
    to proper new-style Zorro drivers.

 drivers/scsi/a2091.c   |  389 +++++++++++++++++---------------
 drivers/scsi/a2091.h   |   46 ++--
 drivers/scsi/a3000.c   |  301 +++++++++++++------------
 drivers/scsi/a3000.h   |   50 ++--
 drivers/scsi/gvp11.c   |  573 +++++++++++++++++++++++++-----------------------
 drivers/scsi/gvp11.h   |   49 ++---
 drivers/scsi/mvme147.c |  178 ++++++++--------
 drivers/scsi/mvme147.h |    4 +-
 drivers/scsi/wd33c93.c |    6 -
 drivers/scsi/wd33c93.h |    1 -
 10 files changed, 820 insertions(+), 777 deletions(-)

Unfortunately I do not have the hardware, so none of this has been actually
tested. Especially easter eggs 20 and 21 are non-trivial and could use some
testing.

Question: If approved, should this go in through the SCSI tree, or can I take
it via the m68k tree?
I have another series of easter eggs to convert all drivers for built-in Amiga
hardware to proper platform drivers, but the A3000 SCSI part depends on this
series.

Thanks for your comments!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
