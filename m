From: "Maciej W. Rozycki" <macro@ds2.pg.gda.pl>
Subject: Re: [PATCH] NCR53c406a.c warning
Date: Fri, 12 Sep 2003 16:16:20 +0200 (MET DST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.GSO.3.96.1030912161154.17936I-100000@delta.ds2.pg.gda.pl>
References: <1063374111.1767.2.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <1063374111.1767.2.camel@mulgrave>
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel Development <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 12 Sep 2003, James Bottomley wrote:

> > NCR53c406a: Apparently wait_intr() is unused, so remove it.
> 
> It is currently unused.  However, the reason is that we removed the scsi
> command method that allows polled operation in a driver (this routine is
> actually polling the interrupt port on the chip).
> 
> I'd like to wait a while to see if anyone still needs this mode when 2.6
> gets a wider test audience.  If you wish, you can surround the routine
> with #if 0 and a comment saying we can junk it later if it really is
> unnecessary.

 I've encountered an ISA adapter using this chip in polled mode (no ISA
IRQ line routed to the chip) quite recently.  But I can't say if the guy
using it won't throw it away before final 2.6. ;-)

-- 
+  Maciej W. Rozycki, Technical University of Gdansk, Poland   +
+--------------------------------------------------------------+
+        e-mail: macro@ds2.pg.gda.pl, PGP key available        +
