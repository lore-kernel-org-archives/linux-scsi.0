From: Julia Lawall <julia@diku.dk>
Subject: RE: [PATCH] scsi: mpt2sas: Add space in printk
Date: Mon, 9 Aug 2010 16:45:19 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.1008091644280.28909@ask.diku.dk>
References: <Pine.LNX.4.64.1008052219190.31692@ask.diku.dk> <20100806075914.GS9031@bicker>
 <1C9608B8A4CD534FB19C7C7543CBB24902991CD597@inbmail02.lsi.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1C9608B8A4CD534FB19C7C7543CBB24902991CD597@inbmail02.lsi.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: Dan Carpenter <error27@gmail.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "Moore, Eric" <Eric.Moore@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 9 Aug 2010, Desai, Kashyap wrote:

> 
> 
> > -----Original Message-----
> > From: Dan Carpenter [mailto:error27@gmail.com]
> > Sent: Friday, August 06, 2010 1:29 PM
> > To: Julia Lawall
> > Cc: James E.J. Bottomley; linux-scsi@vger.kernel.org; linux-
> > kernel@vger.kernel.org; kernel-janitors@vger.kernel.org; Moore, Eric;
> > Desai, Kashyap
> > Subject: [PATCH] scsi: mpt2sas: Add space in printk
> > 
> > Add a space in the output:
> > old:  Discovery: (stop)discovery_status(0x%08x)
> > new:  Discovery: (stop) discovery_status(0x%08x)
> > 
> > Signed-off-by: Dan Carpenter <error27@gmail.com>
> > ---
> > This goes on top of Julia's [PATCH 9/42] drivers/scsi: Adjust
> > confusing if indentation
> > 
> > diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
> > b/drivers/scsi/mpt2sas/mpt2sas_base.c
> > index 12faf64..562b909 100644
> > --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> > +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> > @@ -532,7 +532,7 @@ _base_display_event_data(struct MPT2SAS_ADAPTER
> > *ioc,
> >  		    (event_data->ReasonCode ==
> > MPI2_EVENT_SAS_DISC_RC_STARTED) ?
> >  		    "start" : "stop");
> >  		if (event_data->DiscoveryStatus)
> > -			printk("discovery_status(0x%08x)",
> > +			printk(" discovery_status(0x%08x)",
> I don't see any significant reason for changing print. It not adding any benefit.

It would look a little nicer to have a space after the ) that is printed 
by the previous statement.

julia
