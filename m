From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi sysfs update (base 1/3)
Date: Thu, 7 Nov 2002 09:01:21 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107170121.GA2648@beaverton.ibm.com>
References: <20021107073619.GA1390@beaverton.ibm.com> <20021107182815.A15350@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021107182815.A15350@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@sgi.com>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig [hch@sgi.com] wrote:
> On Wed, Nov 06, 2002 at 11:36:19PM -0800, Mike Anderson wrote:
> > diff -Nru a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> > --- a/drivers/scsi/hosts.c	Wed Nov  6 23:06:51 2002
> > +++ b/drivers/scsi/hosts.c	Wed Nov  6 23:06:51 2002
> > @@ -44,6 +44,7 @@
> >  
> >  #include "scsi.h"
> >  #include "hosts.h"
> > +#include "scsi_sysfs.h"
> 
> Do you really need that header?  All sysfs functionality is needed
> by the midlayer and upper layer drivers anyway.

It probably does not need to be a extra header file. scsi_sysfs.h
could be rolled into scsi.h.

-andmike
--
Michael Anderson
andmike@us.ibm.com

