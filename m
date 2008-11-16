From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] [2/21] Add blk_q_mask
Date: Sun, 16 Nov 2008 08:21:28 -0600
Message-ID: <1226845288.3556.4.camel@localhost.localdomain>
References: <200811161211.212948789@firstfloor.org>
	 <20081115231102.54DF53E661A@basil.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:50004 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931AbYKPOVw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Nov 2008 09:21:52 -0500
In-Reply-To: <20081115231102.54DF53E661A@basil.firstfloor.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: axboe@kernel.dk, linux-scsi@vger.kernel.org

On Sun, 2008-11-16 at 00:11 +0100, Andi Kleen wrote:
> [Merge note: this patch will be in a SCSI patchkit and in the core
> mask allocator patchkit. They are equivalent. If one of them 
> is merged first simply drop it in the other]
> 
> Converts the queue bounce_pfn to a DMA mask suitable for the mask allocator
> 
> Signed-off-by: Andi Kleen <ak@suse.de>
> Signed-off-by: Andi Kleen <andi@firstfloor.org>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

I'm confused by this signoff chain.  You're supposed to give signoffs
from each of the entities whose hands the patch passed through ...
unless you've taken to emailing your own patches to yourself, this
doesn't look right ...

Could you just pick one?  If it's about credit, then the reporting stats
go by Author. All three signoffs  will do is inflate your rank in the
Signed-off-by stats (which I suppose we use for the kernel summit), but
I don't think it will give equal credit to the three entities.

James


