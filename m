From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: State of NCR53c7xx based drivers
Date: Sun, 23 Nov 2003 11:24:44 +0100 (MET)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.21.0311231122500.14422-100000@waterleaf.sonytel.be>
References: <20031122113834.GA8098@lst.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from witte.sonytel.be ([80.88.33.193]:3064 "EHLO witte.sonytel.be")
	by vger.kernel.org with ESMTP id S263345AbTKWKYt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Nov 2003 05:24:49 -0500
In-Reply-To: <20031122113834.GA8098@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Linux/m68k <linux-m68k@lists.linux-m68k.org>, linux-scsi@vger.kernel.org

On Sat, 22 Nov 2003, Christoph Hellwig wrote:
> As for amgia7xx is there a reason we have four different config
> options for this single tiny driver?

I already fixed this in my local tree, for both 2.4.x and 2.6.0, as Willy
suggested this a while ago.

However, I do lack the hardware (and the time, just in case you want to send me
more hardware ;-) to do more clean ups.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


