From: Adrian Bunk <bunk@fs.tum.de>
Subject: [PATCH] NCR53C9x compile fix (fwd)
Date: Tue, 24 Jun 2003 19:51:38 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030624175138.GX3710@fs.tum.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hermes.fachschaften.tu-muenchen.de ([129.187.202.12]:978 "HELO
	hermes.fachschaften.tu-muenchen.de") by vger.kernel.org with SMTP
	id S262430AbTFXRhi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2003 13:37:38 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, trivial@rustcorp.com.au

The patch forwarded below is still needed in 2.5.73.

Please apply
Adrian


----- Forwarded message from Geert Uytterhoeven <geert@linux-m68k.org> -----

Date:	Sun, 15 Jun 2003 20:38:40 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@transmeta.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
    Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] NCR53C9x compile fix

NCR53C9x SCSI: Fix compilation after breakage in 2.5.71

--- linux-2.5.x/drivers/scsi/NCR53C9x.c	Sun Jun 15 10:04:26 2003
+++ linux-m68k-2.5.x/drivers/scsi/NCR53C9x.c	Sun Jun 15 11:49:32 2003
@@ -893,7 +893,7 @@
 int esp_proc_info(struct Scsi_Host *shost, char *buffer, char **start, off_t offset, int length,
 		  int inout)
 {
-	struct NCR_ESP *esp = (struct NCR_ESP *) SCpnt->device->host->hostdata;
+	struct NCR_ESP *esp = (struct NCR_ESP *)shost->hostdata;
 
 	if(inout)
 		return -EINVAL; /* not yet */

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

----- End forwarded message -----
