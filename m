From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] tmscsim: remove internal waiting queue (draft)
Date: Sat, 4 Sep 2004 14:11:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040904141104.A15311@infradead.org>
References: <Pine.LNX.4.60.0409040041030.5266@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:21510 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267920AbUIDNLK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 4 Sep 2004 09:11:10 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.60.0409040041030.5266@poirot.grange>; from g.liakhovetski@gmx.de on Sat, Sep 04, 2004 at 12:48:01AM +0200
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@infradead.org>, Kurt Garloff <garloff@suse.de>, linux-scsi@vger.kernel.org

On Sat, Sep 04, 2004 at 12:48:01AM +0200, Guennadi Liakhovetski wrote:
> Hello
> 
> The attached patch __attempts__ to remove the internal "waiting" (issue) 
> queue, in favour of using the scsi mid-layer command queuing.
> 
> I may very well imaging, that it is not perfeect, __please__, comment.
> 
> I did test it (what a surprise for such a trivial patch:-)), it worked, I 
> even managed to hit that /* Arbitration lost but Reselection won */ case 
> several times under load, although, I still don't undresrtand how this 
> happens and what this means. An explanation would be appreciated.

This one is definitly too complicated for just a quick look :)
You'd make the review easier by splitting it up a little or at least
remove the gratious reformating from this patch.

