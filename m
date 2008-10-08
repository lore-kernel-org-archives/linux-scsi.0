From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [0/21] Remove SCSI unchecked_isa_dma try 3
Date: Wed, 8 Oct 2008 12:21:28 +0200
Message-ID: <20081008102127.GK19428@kernel.dk>
References: <20081002958.641114646@firstfloor.org> <87vdw4klnb.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pasmtpb.tele.dk ([80.160.77.98]:56010 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755706AbYJHKW3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Oct 2008 06:22:29 -0400
Content-Disposition: inline
In-Reply-To: <87vdw4klnb.fsf@basil.nowhere.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

On Wed, Oct 08 2008, Andi Kleen wrote:
> Andi Kleen <andi@firstfloor.org> writes:
> 
> > This reposts the patchkit to remove unchecked_isa_dma which was already
> > discussed some time ago. Instead it replaces it with interfaces
> > that declare the mask. Right now those interfaces map back to GFP_DMA
> > eventually, but it is a preparation for using the DMA mask allocator
> > eventually.
> 
> ping? Any comments please?

FWIW, the patchset looks fine to me.

-- 
Jens Axboe

