From: Bharath Vedartham <linux.bhar@gmail.com>
Subject: Re: [PATCH] message/fusion/mptbase.c: Use kmemdup instead of memcpy
 and kmalloc
Date: Wed, 22 May 2019 21:26:57 +0530
Message-ID: <20190522155657.GA12887@bharath12345-Inspiron-5559>
References: <20190522095335.GA3212@bharath12345-Inspiron-5559>
 <7e2a727333d1d764ae3c0099e050a0521e87d9d8.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7e2a727333d1d764ae3c0099e050a0521e87d9d8.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, May 22, 2019 at 04:48:33AM -0700, Joe Perches wrote:
> On Wed, 2019-05-22 at 15:23 +0530, Bharath Vedartham wrote:
> > Replace kmalloc + memcpy with kmemdup.
> > This was reported by coccinelle.
> []
> > diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
> []
> > @@ -6001,13 +6001,12 @@ mpt_findImVolumes(MPT_ADAPTER *ioc)
> >  	if (mpt_config(ioc, &cfg) != 0)
> >  		goto out;
> >  
> > -	mem = kmalloc(iocpage2sz, GFP_KERNEL);
> > +	mem = kmemdup((u8 *)pIoc2, iocpage2sz, GFP_KERNEL);
> 
> You should remove the unnecessary cast here.
> 
>
Yes! I will change this in v2.

Thanks
Bharath
