From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH 0/4] g_NCR5380: Bug fix and some enhancements
Date: Fri, 9 Dec 2016 09:27:29 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1612090914480.2773@nippy.intranet>
References: <cover.1480917789.git.fthain@telegraphics.com.au> <201612081945.02906.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201612081945.02906.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


On Thu, 8 Dec 2016, Ondrej Zary wrote:

> On Monday 05 December 2016 07:07:19 Finn Thain wrote:
> > This patch series is based on the one submitted recently by Ondrej 
> > Zary.
> >
> > This version has a different irq probing fix for HP C2502 boards and a 
> > more comprehensive patch to change the default irq parameter.
> >
> > It needs testing on actual ISA hardware.
> 
> Tested on HP C2502 (53C400A chip), Canon FG2-5202 (53C400 chip), 
> DTC-3181L (DTCT-436P chip) and MS-PNR (53C400A chip) ISA cards - 
> everything works fine!
> 
> Thanks.
> 

Thanks for testing! I don't recall the MS-PNR board -- some additional 
test coverage is always good.

> Tested-by: Ondrej Zary <linux@rainbow-software.org>
> 
> BTW. The release-region fix (my previous patch 6/6) has disappeared 
> somehow. Should I resubmit?
> 

No need to resubmit it. The patch appears in jejb-scsi/for-next and 
mkp-scsi/4.10/scsi-queue. It fixes a resource leak on an error path, so 
presumably it wasn't important enough for -stable or 4.9-rc.

-- 
