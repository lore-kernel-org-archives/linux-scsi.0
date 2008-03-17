From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [9/20] Add blk_kmalloc/blk_alloc_pages
Date: Mon, 17 Mar 2008 22:34:22 +0100
Message-ID: <20080317213422.GA11966@one.firstfloor.org>
References: <1205445980.2893.85.camel@localhost.localdomain> <20080314134814.GS17940@kernel.dk> <20080314135945.GO2522@one.firstfloor.org> <20080317082711.GB17940@kernel.dk> <20080317083603.GJ27015@one.firstfloor.org> <20080317083832.GE17940@kernel.dk> <20080317085341.GK27015@one.firstfloor.org> <20080317202931.GO17940@kernel.dk> <20080317204548.GB10846@one.firstfloor.org> <20080317204634.GQ17940@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:52932 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYCQVby (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 17:31:54 -0400
Content-Disposition: inline
In-Reply-To: <20080317204634.GQ17940@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

> Look further down in the email, queue_bounce_to_mask() or whatever you
> would want to call it. As also written there, the PRINCIPLE is the same.
> And that is that exporting a to_allocator_mask() helper is a lot saner
> than exporting an allocator api tied to the queue.
> 
> Can we get over this, please?

Ok it would have helped if you had explained why it is saner, but I 
bow to your superior experience on block layer issues.

The only open issue is right now if it isn't better to go back
for automatic bouncing for SCSI scan and the other users. Do you
have an opinion on that too? If you have one can you please convince
James of it too.

-Andi
