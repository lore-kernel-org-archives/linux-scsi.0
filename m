From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: State of NCR53c7xx based drivers
Date: Sun, 23 Nov 2003 18:07:22 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0311231806320.14450-100000@waterleaf.sonytel.be>
References: <20031123175041.A1461@sygehus.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from witte.sonytel.be ([80.88.33.193]:25518 "EHLO witte.sonytel.be")
	by vger.kernel.org with ESMTP id S262729AbTKWRH0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Nov 2003 12:07:26 -0500
In-Reply-To: <20031123175041.A1461@sygehus.dk>
List-Id: linux-scsi@vger.kernel.org
To: Rask Ingemann Lambertsen <rask@sygehus.dk>
Cc: Christoph Hellwig <hch@lst.de>, Linux/m68k <linux-m68k@lists.linux-m68k.org>, linux-scsi@vger.kernel.org

On Sun, 23 Nov 2003, Rask Ingemann Lambertsen wrote:
> On Sat, Nov 22, 2003 at 12:38:34PM +0100, Christoph Hellwig wrote:
> > what's the status of the 53c7xx based drivers, namely amiga7xx,
> > mvme16x and bvme6000?  These are the last ones still using the
> > old 53x7xx instead of the new 53c700 core which despite the
> > name also handles 53c710 chips.
> 
> It might be a good idea to update the comments in the code to say so more
> clearly. At least in 2.6.0-test8, only two changelog entries say so.
> 
> What about the 53c770? This chip is supported by 53c7xx, isn't it? But it
> seems as if 53c7xx uses the exact same code for both 53c710 and 53c770, so
> perhaps you can deal with that easily. Grep did not find any drivers that
> actually make use of the 53c770 support, although it is not unlikely that I
> might have missed something.
> 
> And while we are at amiga7xx and 53c770: There are Amiga SCSI host adapters
> with the 53c770 (CyberStorm PPC/MkIII), although amiga7xx doesn't support
> them. Why?

The usual answer: because no one who has the hardware wrote the support and
submitted it?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

