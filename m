From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: State of NCR53c7xx based drivers
Date: Mon, 24 Nov 2003 21:49:49 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0311242149150.16376-100000@waterleaf.sonytel.be>
References: <Pine.LNX.4.44.0311250551380.22816-100000@leo.crm114.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from witte.sonytel.be ([80.88.33.193]:29335 "EHLO witte.sonytel.be")
	by vger.kernel.org with ESMTP id S261585AbTKXUty (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2003 15:49:54 -0500
In-Reply-To: <Pine.LNX.4.44.0311250551380.22816-100000@leo.crm114.net>
List-Id: linux-scsi@vger.kernel.org
To: Ken Tyler <kent@werple.net.au>
Cc: Rask Ingemann Lambertsen <rask@sygehus.dk>, Linux/m68k <linux-m68k@lists.linux-m68k.org>, linux-scsi@vger.kernel.org

On Tue, 25 Nov 2003, Ken Tyler wrote:
> On Mon, 24 Nov 2003, Rask Ingemann Lambertsen wrote:
> > On Mon, Nov 24, 2003 at 04:12:02PM +1100, Ken Tyler wrote:
> 
> > I'm confused. What SCSI on PPC A4000s is that? Is it the 53c770 on the
> > CyberStorm PPC or the 53c710 on the A4000 tower motherboard?
> 
> Sorry, not clear at all, 53c710 on DKB A4091 in A4000 (not tower) ZORRO 
> slot, with Cyberstorm 060 and 200MHz 604e.
> 
> Is there a 53c710 in A4000 towers and if so is it on the mother board at a 
> fixed address?

A4000T has the 4091 builtin. Look at amiga7xx.c for the fixed address.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

