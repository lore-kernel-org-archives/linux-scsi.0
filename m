From: Andre Hedrick <andre@linux-ide.org>
Subject: Re: [PATCH] ide-scsi changes for new mid level api and error handling
 in 2.5.52
Date: Mon, 23 Dec 2002 11:05:25 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.10.10212231104020.19341-100000@master.linux-ide.org>
References: <20021222171424.GI7990@linnie.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021222171424.GI7990@linnie.riede.org>
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <wrlk@riede.org>
Cc: linux-scsi@vger.kernel.org


There are a few changes I have to fix the ordering of the driver for clean
DMA ATAPI.  These are test on ia64 Itanium 2 from HP.

I will look at the changes again but I agree w/ Doug about the nice job.

Cheers,

On Sun, 22 Dec 2002, Willem Riede wrote:

> On 2002.12.21 20:59 Douglas Gilbert wrote:
> > Willem Riede wrote:
> > > Here is my proposal for bringing ide-scsi in line with the current kernel.
> > > 
> > > The attached patch does:
> > > 
> > 
> > Willem,
> > Good work.
> > 
> Thanks.
> > 
> > BTW Willem's patch is against lk 2.5.52 .
> > 
> Right. And next to this ide-scsi patch, you will also want
> the one line fix to ide.c I posted earlier.
> 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=104017636631422&w=2
> 
> Regards, Willem Riede.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Andre Hedrick
LAD Storage Consulting Group

