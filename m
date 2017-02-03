From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/4] sg: protect access to to 'reserved' page array
Date: Fri, 3 Feb 2017 10:34:19 +0100
Message-ID: <91e3320a-7188-02d6-6678-5f8659f2451e@suse.de>
References: <1486112091-68470-1-git-send-email-hare@suse.de>
 <1486112091-68470-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42087 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752323AbdBCJeZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 04:34:25 -0500
In-Reply-To: <1486112091-68470-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Johannes Thumshirn <jth@kernel.org>, Doug Gilberg <dgilbert@interlog.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 02/03/2017 09:54 AM, Hannes Reinecke wrote:
> The 'reserved' page array is used as a short-cut for mapping
> data, saving us to allocate pages per request.
> However, the 'reserved' array is only capable of holding one
> request, so we need to protect it against concurrent accesses.
>
> Cc: stable@vger.kernel.org
> Reported-by: Dmitry Vyukov <dvyukov@google.com>
> Link: http://www.spinics.net/lists/linux-scsi/msg104326.html
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> Tested-by: Johannes Thumshirn <jth@kernel.org>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
