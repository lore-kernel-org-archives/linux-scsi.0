From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] libsas: fix lockdep issue with ATA
Date: Wed, 18 Jul 2007 10:10:12 +0200
Message-ID: <20070718081012.GD11657@kernel.dk>
References: <1184609751.3447.22.camel@localhost.localdomain> <20070717112955.GR5195@kernel.dk> <1184681570.3378.5.camel@localhost.localdomain> <1184690126.3378.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:22144 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbXGRIKk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jul 2007 04:10:40 -0400
Content-Disposition: inline
In-Reply-To: <1184690126.3378.8.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Tue, Jul 17 2007, James Bottomley wrote:
> On Tue, 2007-07-17 at 09:12 -0500, James Bottomley wrote:
> > > process context, no need to save flags here either.
> > 
> > OK, you caught me ... I was just doing the fastest thing I could to get
> > lockdep to shut up.  By the way, it dumps about 120KB of logs so it's
> > fun to get an actual trace of this...
> > 
> > I'll make the fixes and resubmit
> 
> Here's the update.

Looks good James :-)

-- 
Jens Axboe

