From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 4/4] sg: use standard lists for sg_requests
Date: Fri, 3 Feb 2017 10:38:18 +0100
Message-ID: <2c368a33-0216-6f3d-e630-d790022642e1@suse.de>
References: <1486112091-68470-1-git-send-email-hare@suse.de>
 <1486112091-68470-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42474 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752808AbdBCJiV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 04:38:21 -0500
In-Reply-To: <1486112091-68470-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 02/03/2017 09:54 AM, Hannes Reinecke wrote:
> 'Sg_request' is using a private list implementation; convert it
> to standard lists.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
