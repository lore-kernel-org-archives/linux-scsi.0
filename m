From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] hpsa: fallback to use legacy REPORT PHYS command
Date: Fri, 2 Dec 2016 11:33:52 +0100
Message-ID: <5fa3c268-6cd1-7bd3-238a-6a06bccd55e1@suse.de>
References: <1480674779-118014-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45344 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933373AbcLBKev (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 05:34:51 -0500
In-Reply-To: <1480674779-118014-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Don Brace <don.brace@microsemi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 12/02/2016 11:32 AM, Hannes Reinecke wrote:
> Older SmartArray controllers (eg SmartArray 64xx) do
> not support the extended REPORT PHYS command, so
> fallback to use the legacy version here.
>
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/hpsa.c | 30 +++++++++++++++++++++++++++---
>  1 file changed, 27 insertions(+), 3 deletions(-)
>
Oh fsck.

I messed up.

Please ignore this patch.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
