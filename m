From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [2/21] Add blk_q_mask
Date: Sun, 16 Nov 2008 23:19:59 +0100
Message-ID: <20081116221959.GC6703@one.firstfloor.org>
References: <200811161211.212948789@firstfloor.org> <20081115231102.54DF53E661A@basil.firstfloor.org> <1226845288.3556.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:56665 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbYKPWKX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Nov 2008 17:10:23 -0500
Content-Disposition: inline
In-Reply-To: <1226845288.3556.4.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andi Kleen <andi@firstfloor.org>, axboe@kernel.dk, linux-scsi@vger.kernel.org

> I'm confused by this signoff chain.  You're supposed to give signoffs

That is because I started writing this patchkit at SUSE, then 
worked a bit while I was just on my own (firstfloor) and now
finally did some minor changes at Intel. The bulk of the work
was all done under the SUSE banner, so if it's a problem I can
remove the others, but I thought adding uptodate ones wouldn't
hurt.

> from each of the entities whose hands the patch passed through ...
> unless you've taken to emailing your own patches to yourself, this
> doesn't look right ...
> 
> Could you just pick one?  If it's about credit, then the reporting stats
> go by Author. All three signoffs  will do is inflate your rank in the

That wasn't my intention.

I'll remove the two newer ones in the next batch.

-Andi
