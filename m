From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Fri, 6 Jun 2008 23:23:24 +0300
Message-ID: <20080606202324.GR15085@il.ibm.com>
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp> <da824cf30806041106p1de2355fg38594fcb9dcbf203@mail.gmail.com> <20080605235322L.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:43141 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbYFFUXd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 16:23:33 -0400
Content-Disposition: inline
In-Reply-To: <20080605235322L.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: grundler@google.com, linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org

On Thu, Jun 05, 2008 at 11:49:12PM +0900, FUJITA Tomonori wrote:

> > I didn't check....but reserving MMIO address space might be better
> > done by looking at MMIO ranges routed by all the top level PCI
> > Host-bus controllers (aka PCI-e Root ports). Maybe this is an idea
> > for Mark Gross to implement.
> 
> Calgary IOMMU code does the similar stuff, but I'm not sure. Anyway,
> as you said, it's about what Mark might be interested in.

I'm not sure it's strictly necessary, but we observed Bad Things(TM)
happening when we gave out DMA addresses that corresponded to MMIO
regions and black-listing those regions seemed the safest thing to do.

Cheers,
Muli
