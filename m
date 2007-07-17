From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 09/33] x86-64: update iommu/dma mapping functions to sg
	helpers
Date: Tue, 17 Jul 2007 10:51:23 +0200
Message-ID: <20070717085123.GI5195@kernel.dk>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <11845792681830-git-send-email-jens.axboe@oracle.com> <20070716130608.4d096e29.akpm@linux-foundation.org> <20070716201002.GQ5195@kernel.dk> <20070716133427.e212b753.akpm@linux-foundation.org> <20070716220812.GL4902@rhun.haifa.ibm.com> <20070717073858.GG5195@kernel.dk> <20070717084939.GO4902@rhun.haifa.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:18686 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758046AbXGQIv7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 04:51:59 -0400
Content-Disposition: inline
In-Reply-To: <20070717084939.GO4902@rhun.haifa.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, ak@suse.de

On Tue, Jul 17 2007, Muli Ben-Yehuda wrote:
> On Tue, Jul 17, 2007 at 09:38:59AM +0200, Jens Axboe wrote:
> 
> > On Tue, Jul 17 2007, Muli Ben-Yehuda wrote:
> 
> > > The Xen and Calgary bits are mutually exclusive, so hopefully (a)
> > > will not be held up on account of the Xen merge (or for any other
> > > reason... CalIOC2 machines which are out there won't boot without
> > > it if CONFIG_CALGARY_IOMMU is enabled).
> > 
> > Do you have any comments for the patch to calgary (the mail you are
> > replying to)?
> 
> It looks ok, I just didn't want to ACK it before testing (I'm paranoid
> that way).

That's certainly understandable! Can you mail me an ack once you've had
a chance to test it?

-- 
Jens Axboe

