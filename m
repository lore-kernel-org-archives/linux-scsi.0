From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux-next: Tree for December 29 (fcoe)
Date: Mon, 29 Dec 2008 15:35:20 -0600
Message-ID: <1230586520.3302.61.camel@localhost.localdomain>
References: <20081230031621.60acd90b.sfr@canb.auug.org.au>
	 <20081229123115.9a255fa8.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60153 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753851AbYL2VfY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Dec 2008 16:35:24 -0500
In-Reply-To: <20081229123115.9a255fa8.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, scsi <linux-scsi@vger.kernel.org>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

On Mon, 2008-12-29 at 12:31 -0800, Randy Dunlap wrote:
> On Tue, 30 Dec 2008 03:16:21 +1100 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20081219:
> > 
> > Undropped tree:
> > 	scci
> > 	mtd
> > 
> > Dropped trees (temporarily):
> > 	nfs (akpm request due to 2.6.30 features)
> > 	kvm (build problem)
> > 	rr (build poblem)
> > 	semaphore-removal (due to unfixed conflicts against Linus' tree)
> > 	cpu_alloc (build problem)
> > 	audit (difficult conflicts)
> > 
> > Linus' tree had three build failures requiring patches and one requiring
> > a revert.
> 
> 
> linux-next-20081229/drivers/scsi/fcoe/libfcoe.c:995: error: dereferencing pointer to incomplete type
> linux-next-20081229/drivers/scsi/fcoe/libfcoe.c:1015: error: dereferencing pointer to incomplete type
> 
> (on netdev->name ?)

This looks a bit odd.  libfcoe.h #includes linux/netdevice.h which
defines the structure ... I can't see how netdev could have an
incomplete type.  Could you make libfcoe.i and see what's happening?

Thanks,

James


