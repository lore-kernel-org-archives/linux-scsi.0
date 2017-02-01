From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] sg: protect access to to 'reserved' page array
Date: Wed, 1 Feb 2017 14:18:52 +0100
Message-ID: <20170201131852.GC3661@linux-x5ow.site>
References: <1485948135-83249-1-git-send-email-hare@suse.de>
 <20170201131247.GA5384@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42367 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750847AbdBANSz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Feb 2017 08:18:55 -0500
Content-Disposition: inline
In-Reply-To: <20170201131247.GA5384@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Johannes Thumshirn <jth@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Wed, Feb 01, 2017 at 02:12:48PM +0100, Christoph Hellwig wrote:
> 
> This seems to be abusing an atomic bitflag as a lock.  And I think
> in general we have two different things here that this patch conflates:
> 
>  a) a lock to protect building and using the reserve lists
>  b) a flag is a reservations is in use

I did have a patch doing exactly that but (appart from lockdep complaints) we
decided to drop it, as it made the code even more confusing.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
