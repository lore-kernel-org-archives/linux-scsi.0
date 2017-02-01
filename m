From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] sg: remove unreachable code in SET_FORCE_LOW_DMA
Date: Wed, 1 Feb 2017 14:06:13 +0100
Message-ID: <e9423d7d-9ab4-2172-b461-80c754d7d5af@suse.de>
References: <1485948399-83339-1-git-send-email-hare@suse.de>
 <20170201130048.GA5125@lst.de> <20170201130341.GA5351@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40405 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750925AbdBANGP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Feb 2017 08:06:15 -0500
In-Reply-To: <20170201130341.GA5351@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 02/01/2017 02:03 PM, Christoph Hellwig wrote:
> On Wed, Feb 01, 2017 at 02:00:48PM +0100, Christoph Hellwig wrote:
>> I think the proper fix is to check sfp->low_dma for 0 before updating
>> it, at least that seems to be the intent here.
> 
> Looking at this code a bit more I think the actual, real proper fix
> is to remove the SET_FORCE_LOW_DMA entirely (except maybe the flag
> for SG_GET_LOW_DMA and procfs output).  The block layer already does
> bounce buffering if the DMA addressing constraints are not met,
> so all this should just go away.
> 
Oh, I'm more than happy to do so.

> Btw, any rason Doug isn't on Cc on these sg.c patches?
> 
None. Oversight from my side.

Will be sending a v2 with those two patches rolled into one patchset.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
