From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: SCSI errors on powerpc with 2.6.24-rc6-mm1
Date: Thu, 27 Dec 2007 13:43:35 +0900
Message-ID: <20071227134335O.fujita.tomonori@lab.ntt.co.jp>
References: <20071224044850.GA11449@linux.vnet.ibm.com>
	<20071227121108L.fujita.tomonori@lab.ntt.co.jp>
	<47732C41.7000003@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753407AbXL0EoW@vger.kernel.org>
In-Reply-To: <47732C41.7000003@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: balbir@linux.vnet.ibm.com
Cc: fujita.tomonori@lab.ntt.co.jp, linuxppc-dev@ozlabs.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 27 Dec 2007 10:08:25 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> FUJITA Tomonori wrote:
> > On Mon, 24 Dec 2007 10:18:50 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> [snip]
> 
> > 
> > I might break the IOMMU code. Can you reproduce it easily? If so,
> > reverting my IOMMU patches (I've attached a patch to revert them) fix
> > the problem?
> 
> [snip]
> 
> 
> Yes, this patch fixes the problem for me.

Thanks, so you can reproduce it easily, right?

The problem is that I don't want to revert these changes. I'll see
how these changes cause the problem shortly.
