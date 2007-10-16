From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [GIT PATCH] SCSI updates for 2.6.24
Date: Tue, 16 Oct 2007 08:49:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710160846030.16889@anakin>
References: <1192421381.3429.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932979AbXJPGtX@vger.kernel.org>
In-Reply-To: <1192421381.3429.6.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, Boaz Harrosh <bharrosh@panasas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Linux/m68k <linux-m68k@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, 15 Oct 2007, James Bottomley wrote:
> This is the accumulated updates queued for 2.6.24.  It contains the
> usual slew of driver updates, plus some gdth and advansys rewrites.  We
> still have some outstanding bugs in gdth and fc4 for which I'm hoping to
> sweep fixes into the next update.

> Boaz Harrosh (12):
>       NCR5380: Use scsi_eh API for REQUEST_SENSE invocation

This change broke compilation of the mac_scsi.c driver:

| linux/drivers/scsi/NCR5380.c: In function 'NCR5380_information_transfer':
| linux/drivers/scsi/NCR5380.c:2282: error: 'struct NCR5380_hostdata' has no member named 'ses'
| linux/drivers/scsi/NCR5380.c:2283: error: 'struct NCR5380_hostdata' has no member named 'ses'
| linux/drivers/scsi/NCR5380.c:2284: error: 'struct NCR5380_hostdata' has no member named 'ses'
| linux/drivers/scsi/NCR5380.c:2288: error: 'struct NCR5380_hostdata' has no member named 'ses'

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
