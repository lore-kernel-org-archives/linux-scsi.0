From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] drivers/scsi/aic7xxx/aic7xxx_osm_pci.c - remove pointer
 comparison to 0
Date: Mon, 11 Feb 2008 09:17:42 -0800
Message-ID: <20080211091742.dff2e2da.rdunlap@xenotime.net>
References: <1202708852.13411.3.camel@localhost>
	<1202743820.3122.13.camel@localhost.localdomain>
	<1202749685.13411.11.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xenotime.net ([66.160.160.81]:43228 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755157AbYBKRRs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 11 Feb 2008 12:17:48 -0500
Received: from midway.site ([71.245.99.126]) by xenotime.net for <linux-scsi@vger.kernel.org>; Mon, 11 Feb 2008 09:17:42 -0800
In-Reply-To: <1202749685.13411.11.camel@localhost>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

On Mon, 11 Feb 2008 09:08:05 -0800 Joe Perches wrote:

> On Mon, 2008-02-11 at 09:30 -0600, James Bottomley wrote:
> > On Sun, 2008-02-10 at 21:47 -0800, Joe Perches wrote:
> > > -       if (request_region(*base, 256, "aic7xxx") == 0)
> > > +       if (!request_region(*base, 256, "aic7xxx"))
> > 
> > This patch is completely pointless.
> 
> It removes a sparse warning.

I try to say that in the patch description.  Andrew also tries
to enforce such errors/warnings in patch descriptions....
	
> > There's a marginal preference for if (!x) over if (x == NULL)
> > for pointers, but it's still up to a driver writer if they wish to use
> > the marginally unpreferred form.
> 
> Use == NULL then if you care to.

---
~Randy
