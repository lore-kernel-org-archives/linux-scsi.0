From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [9/20] Add blk_kmalloc/blk_alloc_pages
Date: Mon, 17 Mar 2008 21:45:48 +0100
Message-ID: <20080317204548.GB10846@one.firstfloor.org>
References: <20080307653.720459648@firstfloor.org> <20080307175408.E290E1B41AE@basil.firstfloor.org> <1205445980.2893.85.camel@localhost.localdomain> <20080314134814.GS17940@kernel.dk> <20080314135945.GO2522@one.firstfloor.org> <20080317082711.GB17940@kernel.dk> <20080317083603.GJ27015@one.firstfloor.org> <20080317083832.GE17940@kernel.dk> <20080317085341.GK27015@one.firstfloor.org> <20080317202931.GO17940@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:48259 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYCQUnU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 16:43:20 -0400
Content-Disposition: inline
In-Reply-To: <20080317202931.GO17940@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

> The queue_to_gfp_mask() would make that conversion equally simple.

Except that there is no gfp for this in the mask allocator world.
If I wanted to stay with GFPs i would have never attempted any
of this in the first place.

-Andi

