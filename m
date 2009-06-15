From: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] dma-debug: disable DMA_API_DEBUG for now
Date: Mon, 15 Jun 2009 09:46:17 +0200
Message-ID: <20090615074616.GD18638@8bytes.org>
References: <20090605173232N.fujita.tomonori@lab.ntt.co.jp> <20090605104132.GE24836@amd.com> <64bb37e0906101341j341f5179o9abfa888a6b96fc3@mail.gmail.com> <20090611081032.GN5139@amd.com> <64bb37e0906111038h1a5b9f17oec6c6368d2fbd36d@mail.gmail.com> <20090612141346.GY5139@amd.com> <64bb37e0906131008x59b25b94u501fc2192cc28be0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 8bytes.org ([88.198.83.132]:55929 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750877AbZFOHqQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jun 2009 03:46:16 -0400
Content-Disposition: inline
In-Reply-To: <64bb37e0906131008x59b25b94u501fc2192cc28be0@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Joerg Roedel <joerg.roedel@amd.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu, lethal@linux-sh.org, hancockrwd@gmail.com, jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, Jun 13, 2009 at 07:08:01PM +0200, Torsten Kaiser wrote:
> On Fri, Jun 12, 2009 at 4:13 PM, Joerg Roedel<joerg.roedel@amd.com> wrote:
> > On Thu, Jun 11, 2009 at 07:38:47PM +0200, Torsten Kaiser wrote:
> >> DMA-API: device driver tries to free DM
> >> A memory it has not allocated [device address=0x000000011e4c3000]
> >> [size=4096 bytes]
> >
> > Hmm, looking again over the code I've seen that the ref
> > dma_debug_entries are not alway filled with all necessary information
> > for best-fit. Can you please try if you still get false warnings when
> > you apply the two patches attached instead of the one I sent yesterday?
> 
> I tested these patches
> (0001-dma-debug-check-for-sg_call_ents-in-best-fit-algorit.patch and
> 0002-dma-debug-be-more-careful-when-building-reference-en.patch)
> against 2.6.30-git6 and did not see any warnings.
> 
> I can't be 100% sure about the fix, because I do not have a reliable
> trigger, but it looks quite good.

Ok cool, I will push these two patches upstream then and will send them
to -stable too. So we get this fixed in a 30.x release too. Thanks a lot
for your testing.

	Joerg

