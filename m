From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] [29/82] x86_64: Rename IOMMU option, fix help and mark option embedded.
Date: Sun, 25 Jun 2006 21:32:41 +0200
Message-ID: <200606252132.41121.ak@suse.de>
References: <449C852C.mailCZT11F9YB@suse.de> <200606251722.23294.ak@suse.de> <20060625190054.GA6570@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:10176 "EHLO mx1.suse.de")
	by vger.kernel.org with ESMTP id S932231AbWFYTjm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jun 2006 15:39:42 -0400
In-Reply-To: <20060625190054.GA6570@devserv.devel.redhat.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@redhat.com>
Cc: torvalds@osdl.org, discuss@x86-64.org, akpm@osdl.org, markh@osdl.org, linux-scsi@vger.kernel.org, axboe@suse.de

On Sunday 25 June 2006 21:00, Alan Cox wrote:
> On Sun, Jun 25, 2006 at 05:22:23PM +0200, Andi Kleen wrote:
> > > Older aacraid hardware cannot address the 3-4GB range where the iommu
> > > remaps pages. As the PCI DMA implementation for the x86-64 is flawed and
> > > doesn't support any nice way to deal with this via swiotlb instead the
> > > driver handles it internally.
> > 
> > Then you should just force a low bounce pfn < 0xfffffff for the block device - 
> > then the block layer  should use GFP_DMA bouncing.
> 
> From a tiny 16MB DMA pool that can't sustain the required load ? Or has that
> bit changed.

It should be ok because it blocks. It will be slow, but what else do you expect
from broken hardware like this? 

-Andi
