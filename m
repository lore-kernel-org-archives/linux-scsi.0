From: Rask Ingemann Lambertsen <rask@sygehus.dk>
Subject: Re: Using ncr53c8xx.c for a 53c770 chip
Date: Tue, 13 Jan 2004 19:57:50 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040113195747.C1738@sygehus.dk>
References: <20031122113834.GA8098@lst.de> <20031123175041.A1461@sygehus.dk> <1069606797.2066.2.camel@mulgrave> <20040113145553.A1738@sygehus.dk> <1074011584.2173.126.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 0x50a144b9.albnxx15.adsl-dhcp.tele.dk ([80.161.68.185]:3845
	"EHLO 0x50a144b9.albnxx15.adsl-dhcp.tele.dk") by vger.kernel.org
	with ESMTP id S265155AbUAMS5y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jan 2004 13:57:54 -0500
Content-Disposition: inline
In-Reply-To: <1074011584.2173.126.camel@mulgrave>; from James.Bottomley@steeleye.com on Tue, Jan 13, 2004 at 11:33:03AM -0500
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Jan 13, 2004 at 11:33:03AM -0500, James Bottomley wrote:
> On Tue, 2004-01-13 at 08:55, Rask Ingemann Lambertsen wrote:
> 
> > I also need some help filling in the ncr_slot structure. The registers are
> > memory mapped at bus address 0xf40000 and the script RAM is memory mapped at
> > bus address 0xf41000. So I guess base is for the registers, base2 is for
> > the script RAM and that *_v is for the virtual memory addresses of the above.
> > That still leaves me with io_port, base_c, base2_c and base_io.
> 
> That should be correct...although I've not tested it, it might be wise
> to begin without the FE_RAM as well.  I can check this with the
> NCR_Q720, though if you get problems.  Although it doesn't have on-chip
> ram for scripts, the board itself has 2Mb of ram behind the MCA window

OK. Btw, searching for paddr2 shows use of vtobus(). :-(

> > Where do I tell the driver about the SCSI clock (50 MHz)?
> 
> The driver will work it out...it has its own timing routine.

Good. I'm not entirely sure that all boards use a 50 MHz clock. Partly
because several models of the board exists and partly because some people
overclock their boards.

-- 
Regards,
Rask Ingemann Lambertsen
