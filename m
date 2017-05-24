From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 01/31] Split scsi_internal_device_block()
Date: Wed, 24 May 2017 09:36:59 +0200
Message-ID: <484d74a8-f33b-948b-8025-4fa73eed7447@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-2-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51091 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S966696AbdEXHhF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 03:37:05 -0400
In-Reply-To: <20170524003420.5381-2-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>

On 05/24/2017 02:33 AM, Bart Van Assche wrote:
> Instead of passing a "wait" argument to scsi_internal_device_block(),
> split this function into a function that waits and a function that
> doesn't wait. This will make it easier to serialize SCSI device state
> changes through a mutex.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
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
