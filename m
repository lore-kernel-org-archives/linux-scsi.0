From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] 5/6: scsi_inq_timeout
Date: Mon, 19 Apr 2004 09:41:06 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040419094106.A31555@beaverton.ibm.com>
References: <20040418185957.GH4868@tpkurt.garloff.de> <20040418202109.C3393@infradead.org> <20040418221610.GN4868@tpkurt.garloff.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:58844 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261468AbUDSQlW
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Apr 2004 12:41:22 -0400
Content-Disposition: inline
In-Reply-To: <20040418221610.GN4868@tpkurt.garloff.de>; from garloff@suse.de on Mon, Apr 19, 2004 at 12:16:10AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Kurt Garloff <garloff@suse.de>, Christoph Hellwig <hch@infradead.org>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, Apr 19, 2004 at 12:16:10AM +0200, Kurt Garloff wrote:
> On Sun, Apr 18, 2004 at 08:21:09PM +0100, Christoph Hellwig wrote:
> > On Sun, Apr 18, 2004 at 08:59:57PM +0200, Kurt Garloff wrote:
> > > +#ifdef __powerpc64__
> > > +static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+25;
> > > +#else
> > > +static unsigned int scsi_inq_timeout = SCSI_TIMEOUT/HZ+3;
> > > +#endif
> > 
> > Huh?  per-arch ifdefs in the scsi code are completely bogus.
> 
> Well, those broken chips seem to be very common on machines from
> a specific vendor that ships PPC64 hardware ...
> That hunk could be dropped of course in mainline, I would not mind.

Why not increase it for all cases? And/or make it a config value? 

It won't slow down functioning hardware, just the cases where we get no
response.

-- Patrick Mansfield
