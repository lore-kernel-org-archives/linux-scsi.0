From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] scsi sysfs update (base 1/3)
Date: Thu, 7 Nov 2002 09:22:47 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021107092247.A10258@eng2.beaverton.ibm.com>
References: <20021107073619.GA1390@beaverton.ibm.com> <20021107182815.A15350@sgi.com> <20021107170121.GA2648@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20021107170121.GA2648@beaverton.ibm.com>; from andmike@us.ibm.com on Thu, Nov 07, 2002 at 09:01:21AM -0800
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christoph Hellwig <hch@sgi.com>, linux-scsi@vger.kernel.org

On Thu, Nov 07, 2002 at 09:01:21AM -0800, Mike Anderson wrote:
> Christoph Hellwig [hch@sgi.com] wrote:
> > On Wed, Nov 06, 2002 at 11:36:19PM -0800, Mike Anderson wrote:

> > >  #include "scsi.h"
> > >  #include "hosts.h"
> > > +#include "scsi_sysfs.h"
> > 
> > Do you really need that header?  All sysfs functionality is needed
> > by the midlayer and upper layer drivers anyway.
> 
> It probably does not need to be a extra header file. scsi_sysfs.h
> could be rolled into scsi.h.

You would have to put them in hosts.h though to get inlines that
use Scsi_Host.

-- Patrick Mansfield
