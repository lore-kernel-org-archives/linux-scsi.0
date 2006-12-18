From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [RFC PATCH] m68k: switch to 53c700 driver
Date: Mon, 18 Dec 2006 10:34:21 +0100 (CET)
Message-ID: <Pine.LNX.4.62.0612181032080.24587@pademelon.sonytel.be>
References: <Pine.LNX.4.62.0510071024370.26010@numbat.sonytel.be>
 <20051007134232.GA6490@levanta.com> <1128693232.5041.7.camel@laptop-lcs.localdomain>
 <20051115095152.GA23470@infradead.org> <20051115101709.GK7031@2004.bluespice.org>
 <20051115103034.GA24352@infradead.org> <20051115113225.GS5252@levanta.com>
 <20060707124444.GA11199@infradead.org> <20060709111648.GR15414@levanta.com>
 <1152444304.5567.2.camel@kars.perseus.home> <20061030111311.GA756@infradead.org>
 <1162331224.7805.18.camel@kars.perseus.home> <1166394517.9647.22.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vervifontaine.sonytel.be ([80.88.33.193]:56260 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753666AbWLRJzE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Dec 2006 04:55:04 -0500
In-Reply-To: <1166394517.9647.22.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Kars de Jong <jongk@linux-m68k.org>, Christoph Hellwig <hch@infradead.org>, Richard Hirst <rhirst@levanta.com>, Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, linux-m68k@vger.kernel.org

On Sun, 17 Dec 2006, James Bottomley wrote:
> On Tue, 2006-10-31 at 22:47 +0100, Kars de Jong wrote:
> > On ma, 2006-10-30 at 11:13 +0000, Christoph Hellwig wrote:
> > > Any updates?  Honestly, I do not plan to touch the current 53c7xx/etc
> > > mess in the upoming request_buffer transition, and unless the m68k
> > > folks provide the new 53c700-based driver I'll just submit a patch to
> > > rip 53c7xx and users out without replacement.
> > 
> > OK, here's the patch, without the m68k generic iomap changes.
> 
> Could you regenerate this against the current git-head?  I've tried
> several merge points and I still can't get it to apply ... I suspect it
> had additional m68k fixes in the original file.

Yes, it was against the m68k tree.

If Kars doesn't respond, you can try

m68k-generic-io.diff
m68k-mvme-scsi-rename.diff
m68k-53c700-scsi.diff

from http://linux-m68k-cvs.ubb.ca/~geert/linux-m68k-2.6.x-merging/. These are
against 2.6.19.

BTW, are you interested in more Scsi_Cmnd -> struct scsi_cmnd patches? I have a
few of them lying around.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
