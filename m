From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [0/21] Remove SCSI unchecked_isa_dma try 3
Date: Wed, 08 Oct 2008 01:53:12 +0200
Message-ID: <87vdw4klnb.fsf@basil.nowhere.org>
References: <20081002958.641114646@firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:34618 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754372AbYJGXxP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Oct 2008 19:53:15 -0400
In-Reply-To: <20081002958.641114646@firstfloor.org> (Andi Kleen's message of "Thu,  2 Oct 2008 09:58:38 +0200 (CEST)")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, axboe@kernel.dk

Andi Kleen <andi@firstfloor.org> writes:

> This reposts the patchkit to remove unchecked_isa_dma which was already
> discussed some time ago. Instead it replaces it with interfaces
> that declare the mask. Right now those interfaces map back to GFP_DMA
> eventually, but it is a preparation for using the DMA mask allocator
> eventually.

ping? Any comments please?

-Andi

-- 
ak@linux.intel.com
