From: Rask Ingemann Lambertsen <rask@sygehus.dk>
Subject: Re: State of NCR53c7xx based drivers
Date: Mon, 24 Nov 2003 15:26:57 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031124152653.A1292@sygehus.dk>
References: <20031123232126.B1657@sygehus.dk> <Pine.LNX.4.44.0311241553080.17702-100000@leo.crm114.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0x50a144f4.albnxx15.adsl-dhcp.tele.dk ([80.161.68.244]:28164
	"EHLO 0x50a144f4.albnxx15.adsl-dhcp.tele.dk") by vger.kernel.org
	with ESMTP id S263734AbTKXO07 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Nov 2003 09:26:59 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311241553080.17702-100000@leo.crm114.net>; from kent@werple.net.au on Mon, Nov 24, 2003 at 04:12:02PM +1100
List-Id: linux-scsi@vger.kernel.org
To: Ken Tyler <kent@werple.net.au>
Cc: Linux/m68k <linux-m68k@lists.linux-m68k.org>, linux-scsi@vger.kernel.org

On Mon, Nov 24, 2003 at 04:12:02PM +1100, Ken Tyler wrote:
> On Sun, 23 Nov 2003, Rask Ingemann Lambertsen wrote:
> 
> > I have an Amiga with a CyberStorm PPC board and wouldn't mind having Linux
> > running on it. What would be a good name for the driver?
> 
> Which Amiga and which PPC board?

Amiga 4000 desktop and CyberStorm PPC with '060@50 MHz and 604e@233 MHz.

> SCSI works on ppc 1200s but not reliably on ppc 4000s.  I tried many, many 
> times to fix 53c710.c (with endless help from Richard Hirst) all to no 
> avail.

I'm confused. What SCSI on PPC A4000s is that? Is it the 53c770 on the
CyberStorm PPC or the 53c710 on the A4000 tower motherboard?

> At this point I decided the driver was probably OK all along and the 
> problem is else where, either in the logic that connects ZORRO to PPC or a 
> deadlock in interrupt code but this is stabbing in the dark.

The Zorro<->PPC logic should be out of the equation on the CyberStorm PPC
since the 53c770 is connected directly to the processor bus.

-- 
Regards,
Rask Ingemann Lambertsen
