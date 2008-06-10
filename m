From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH 2/2] cciss: bump version to .20 to reflect new HW support
Date: Tue, 10 Jun 2008 21:12:49 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77881F2C828381@GVW0547EXC.americas.hpqcorp.net>
References: <20080610161404.GB6808@roadking.ldev.net>
 <20080610135026.f17a2d3a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:40319 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbYFJVNO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jun 2008 17:13:14 -0400
In-Reply-To: <20080610135026.f17a2d3a.akpm@linux-foundation.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "jens.axboe@oracle.com" <jens.axboe@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Patterson, Andrew D (Linux R&D)" <andrew.patterson@hp.com>, "Chen, Justin" <justin.chen@hp.com>



> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Tuesday, June 10, 2008 3:50 PM
> To: Miller, Mike (OS Dev)
> Cc: jens.axboe@oracle.com; linux-kernel@vger.kernel.org;
> linux-scsi@vger.kernel.org; Patterson, Andrew D (Linux R&D);
> Chen, Justin
> Subject: Re: [PATCH 2/2] cciss: bump version to .20 to
> reflect new HW support
>
> On Tue, 10 Jun 2008 11:14:04 -0500
> Mike Miller <mike.miller@hp.com> wrote:
>
> > PATCH 2/2
> > This patch bumps the driver version to 3.6.20 to reflect the new
> > hardware support from patch 1 of this set. Please consider
> this for inclusion.
> >
> > Signed-off-by: Mike Miller <mike.miller@hp.com>
> >
> > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c index
> > ced904d..c21a5a9 100644
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -53,16 +53,16 @@
> >  #include <linux/scatterlist.h>
> >
> >  #define CCISS_DRIVER_VERSION(maj,min,submin)
> > ((maj<<16)|(min<<8)|(submin)) -#define DRIVER_NAME "HP CISS
> Driver (v 3.6.14)"
> > -#define DRIVER_VERSION CCISS_DRIVER_VERSION(3,6,14)
> > +#define DRIVER_NAME "HP CISS Driver (v 3.6.20)"
> > +#define DRIVER_VERSION CCISS_DRIVER_VERSION(3, 6, 20)
> >
> >  /* Embedded module documentation macros - see modules.h */
> > MODULE_AUTHOR("Hewlett-Packard Company");
> -MODULE_DESCRIPTION("Driver
> > for HP Controller SA5xxx SA6xxx version 3.6.14");
> > +MODULE_DESCRIPTION("Driver for HP Smart Array Controllers");
> >  MODULE_SUPPORTED_DEVICE("HP SA5i SA5i+ SA532 SA5300 SA5312
> SA641 SA642 SA6400"
> >                       " SA6i P600 P800 P400 P400i E200
> E200i E500 P700m"
> >                       " Smart Array G2 Series SAS/SATA
> Controllers");
> > -MODULE_VERSION("3.6.14");
> > +MODULE_VERSION("3.6.20");
> >  MODULE_LICENSE("GPL");
> >
> >  #include "cciss_cmd.h"
>
> I think it would be more logical to fold these two patches together.

Jens at one time suggested I keep the version patch separate, IIRC.
>
> I believe we should include this new device support in 2.6.25.x, yes?

Yes, I'd like to see the support in 2.6.25.x.

-- mikem
>
