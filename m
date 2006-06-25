From: Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] [29/82] x86_64: Rename IOMMU option, fix help and mark option embedded.
Date: Sun, 25 Jun 2006 15:00:54 -0400
Message-ID: <20060625190054.GA6570@devserv.devel.redhat.com>
References: <449C852C.mailCZT11F9YB@suse.de> <20060624231433.GA24862@devserv.devel.redhat.com> <200606251722.23294.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44425 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S965319AbWFYTBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jun 2006 15:01:12 -0400
Content-Disposition: inline
In-Reply-To: <200606251722.23294.ak@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: Alan Cox <alan@redhat.com>, torvalds@osdl.org, discuss@x86-64.org, akpm@osdl.org, markh@osdl.org, linux-scsi@vger.kernel.org, axboe@suse.de

On Sun, Jun 25, 2006 at 05:22:23PM +0200, Andi Kleen wrote:
> > Older aacraid hardware cannot address the 3-4GB range where the iommu
> > remaps pages. As the PCI DMA implementation for the x86-64 is flawed and
> > doesn't support any nice way to deal with this via swiotlb instead the
> > driver handles it internally.
> 
> Then you should just force a low bounce pfn < 0xfffffff for the block device - 
> then the block layer  should use GFP_DMA bouncing.

>From a tiny 16MB DMA pool that can't sustain the required load ? Or has that
bit changed.

Alan



