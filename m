From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] clean up some more tmscsim scan logic
Date: Tue, 24 Aug 2004 13:36:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040824113641.GB16546@lst.de>
References: <20040817163323.GA16799@lst.de> <Pine.LNX.4.60.0408172136340.5224@poirot.grange> <20040819113327.GA21326@lst.de> <Pine.LNX.4.60.0408192300530.5248@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:26267 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S267565AbUHXLgn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 07:36:43 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0408192300530.5248@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Thu, Aug 19, 2004 at 11:16:00PM +0200, Guennadi Liakhovetski wrote:
> That's actually what I was reading and that's where I didn't understand:
> 
>  * Notes:
>  *    This has the unfortunate side effect that if a shost adapter does
>  *    not automatically request sense information, that we end up shutting
>  *    it down before we request it.  All shosts should be doing this
> 								^^^^
>  *    anyways, so for now all I have to say is tough noogies if you end up
>  *    in here.  On second thought, this is probably a good idea.  We
>  *    *really* want to give authors an incentive to automatically request
>  *    this.
> 
> So, I failed to understand if "this" above means "All shosts should be 
> automatically requesting sense" or the opposite.

I'm pretty sure it means the HBA or LLDD should do it.  I'll send James
a patch to fix up the wording.


> Then the "second 
> thought"... So, you mean LLDs should really auto-request sense on 
> failures. Well, if we detect an error condition when we are CONNECTED to a 
> host, it should be possible to directly send a REQUEST SENSE - the bus 
> should be ours at this time, right?

I think so.

