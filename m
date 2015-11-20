From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 00/71] More fixes, cleanup and modernization for NCR5380
 drivers
Date: Fri, 20 Nov 2015 19:19:21 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1511201909540.15006@nippy.intranet>
References: <20151118083455.331768508@telegraphics.com.au> <201511181235.15663.linux@rainbow-software.org> <alpine.LNX.2.00.1511191321010.9967@nippy.intranet> <201511192350.58253.linux@rainbow-software.org> <alpine.LNX.2.00.1511201238430.31133@nippy.intranet>
 <alpine.LNX.2.00.1511201820130.14450@nippy.intranet> <20151120073354.GA26080@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:45630 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934844AbbKTITn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2015 03:19:43 -0500
In-Reply-To: <20151120073354.GA26080@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ondrej Zary <linux@rainbow-software.org>, Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


On Thu, 19 Nov 2015, Christoph Hellwig wrote:

> On Fri, Nov 20, 2015 at 06:21:06PM +1100, Finn Thain wrote:
>
> > > Not sure what module was being probed here. I presume it was 
> > > g_NCR5380 or g_NCR5380_mmio. Neither of these calls 
> > > 'scsi_scan_host'. I'm not sure what the implications are (?)
> > 
> > Nevermind. The call is in scsi_module.c.
> 
> Which, btw really need to go away.  If you want to resurrect the
> ISA drivers they need to be converted to proper probing.

Yes. I didn't do that conversion because I don't have ISA hardware and I 
don't understand ISA probing.

The present patch set doesn't seek to resurrect the ISA drivers. But I am 
trying to avoid regressions.

I have mixed feelings about the ISA drivers. ISA DMA support complicates 
things (it was never completed) and DMA seems to be the main obstacle to 
merging the two core driver forks.

-- 
