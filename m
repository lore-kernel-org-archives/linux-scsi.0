From: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Subject: Re: [PATCH] remove drivers/fc4/
Date: Sun, 19 Jun 2005 22:23:38 +0100
Message-ID: <20050619212338.GN29811@parcelfarce.linux.theplanet.co.uk>
References: <20050619113723.GA18757@lst.de> <20050619.125747.35507641.davem@davemloft.net> <20050619204008.GA26389@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:22988 "EHLO
	parcelfarce.linux.theplanet.co.uk") by vger.kernel.org with ESMTP
	id S261327AbVFSVWW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 17:22:22 -0400
Content-Disposition: inline
In-Reply-To: <20050619204008.GA26389@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "David S. Miller" <davem@davemloft.net>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sun, Jun 19, 2005 at 10:40:08PM +0200, Christoph Hellwig wrote:
> On Sun, Jun 19, 2005 at 12:57:47PM -0700, David S. Miller wrote:
> > From: Christoph Hellwig <hch@lst.de>
> > Subject: [PATCH] remove drivers/fc4/
> > Date: Sun, 19 Jun 2005 13:37:24 +0200
> > 
> > > This code doesn't work since 2.2.x times, uses various obsolete APIs,
> > > pokes into the midlayer code where it shouldn't and thus won't even
> > > have a chance to compile after my next round of patches.
> > > 
> > > Let's get rid of it, anyone who wants to resurrect it can find it
> > > in the archives, and it'll require a major rewrite anyway.
> > 
> > It does work for some people.  People do use it.
> 
> Who?  looking at sparclinux doesn't show anyone who got it working
> since 2.2.x days.

Umm...  sparc64 does work with 2.6.  I don't have any fiberchannel
hardware in question, but both 2.4 and 2.6 work on Ultra just fine.
Ought to try and resurrect the quad-SS20 box and see what's the
situation with sparc32 one of these days...
