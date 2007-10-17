From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] SPARC64: fix iommu sg chaining
Date: Wed, 17 Oct 2007 13:13:48 +0200
Message-ID: <20071017111348.GX5043@kernel.dk>
References: <20071017091629.GK5043@kernel.dk> <20071017182401X.fujita.tomonori@lab.ntt.co.jp> <20071017.024547.74747794.davem@davemloft.net> <20071017200843O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:22716 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932323AbXJQLOQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Oct 2007 07:14:16 -0400
Content-Disposition: inline
In-Reply-To: <20071017200843O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Oct 17 2007, FUJITA Tomonori wrote:
> On Wed, 17 Oct 2007 02:45:47 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Date: Wed, 17 Oct 2007 18:24:01 +0900
> > 
> > > On Wed, 17 Oct 2007 11:16:29 +0200
> > > Jens Axboe <jens.axboe@oracle.com> wrote:
> > > 
> > > > On Wed, Oct 17 2007, David Miller wrote:
> > > > > I would suggest that other sg_last() uses be audited for the same bug.
> > > > 
> > > > Agree.
> > > 
> > > Only libata, I think.
> > 
> > There are a few other spots, like ide-scsi
> 
> Oops, I missed that. But seems that we have only three, ide-scsi,
> libata, sparc64 iommu.

And now only ide-scsi and libata, Dave killed sg_last() in sparc64
already. So less than I remember, I'd say kill it NOW...

-- 
Jens Axboe

