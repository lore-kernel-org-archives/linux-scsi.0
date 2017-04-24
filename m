From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] sg: reset 'res_in_use' after unlinking reserved array
Date: Mon, 24 Apr 2017 10:32:15 +0200
Message-ID: <20170424083214.GA29543@linux-x5ow.site>
References: <1493022396-107620-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33679 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1166614AbdDXIcS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 Apr 2017 04:32:18 -0400
Content-Disposition: inline
In-Reply-To: <1493022396-107620-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On Mon, Apr 24, 2017 at 10:26:36AM +0200, Hannes Reinecke wrote:
> Once the reserved page array is unused we can reset the
> 'res_in_use' state; here we can do a lazy update without
> holding the mutex as we only need to check against
> concurrent access, not concurrent release.
> 
> Fixes: 1bc0eb0 ("scsi: sg: protect accesses to 'reserved' page array")
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
