From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [0/21] Remove isa_unchecked_dma and some more GFP_DMAs in the mid layer v2
Date: Thu, 6 Mar 2008 23:19:55 +0100
Message-ID: <20080306221955.GC31833@one.firstfloor.org>
References: <20080306951.147874949@firstfloor.org> <1204841607.3062.67.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:41549 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbYCFWSZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2008 17:18:25 -0500
Content-Disposition: inline
In-Reply-To: <1204841607.3062.67.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-scsi@vger.kernel.org, axboe@kernel.dk

On Thu, Mar 06, 2008 at 04:13:27PM -0600, James Bottomley wrote:
> On Thu, 2008-03-06 at 21:51 +0100, Andi Kleen wrote:
> > This is v2 of the patchkit. I believe I addressed all review feedback
> > and did some more improvements.
> 
> I believe I objected to substituting the single bit unchecked_isa_dma
> flag with a u64 sense_mask.  That still seems to be present:

Ok. It was a micro optimization because I realized most drivers
I looked at don't need sense_buffer bouncing (because they don't
don't dma it). But I don't feel very strongly about optimizing
these drivers.

I guess I can move it over to blk_kmalloc() too.

-Andi
