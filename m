From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] remove drivers/fc4/
Date: Sun, 19 Jun 2005 22:40:08 +0200
Message-ID: <20050619204008.GA26389@lst.de>
References: <20050619113723.GA18757@lst.de> <20050619.125747.35507641.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:1461 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261322AbVFSUkP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Jun 2005 16:40:15 -0400
Content-Disposition: inline
In-Reply-To: <20050619.125747.35507641.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>
Cc: jejb@steeleye.com, linux-scsi@vger.kernel.org

On Sun, Jun 19, 2005 at 12:57:47PM -0700, David S. Miller wrote:
> From: Christoph Hellwig <hch@lst.de>
> Subject: [PATCH] remove drivers/fc4/
> Date: Sun, 19 Jun 2005 13:37:24 +0200
> 
> > This code doesn't work since 2.2.x times, uses various obsolete APIs,
> > pokes into the midlayer code where it shouldn't and thus won't even
> > have a chance to compile after my next round of patches.
> > 
> > Let's get rid of it, anyone who wants to resurrect it can find it
> > in the archives, and it'll require a major rewrite anyway.
> 
> It does work for some people.  People do use it.

Who?  looking at sparclinux doesn't show anyone who got it working
since 2.2.x days.

> It built just fine before changes started going in
> lately.  Removing it is not a magic escape hatch you
> get to use because you want to change some interfaces
> but don't know how to do so without breaking the
> driver.

It's doing completely stupid things about poking into EH internals.
This never was an API and no other driver does this - and I'm not
going to do anything but if 0'ing large parts of the drivers to
'fix' the build because there's very little that wasn't totally
broken before.

Note that you actually agreed on removing them from the tree back
in June 2004.

