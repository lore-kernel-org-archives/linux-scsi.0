From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 20/31] scsi: Only add commands to the device command list
 if required by the LLD
Date: Wed, 24 May 2017 08:07:48 +0200
Message-ID: <fce61a1e-fa89-d21b-b064-d79e23bb0507@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-21-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59293 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933980AbdEXGHu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 May 2017 02:07:50 -0400
In-Reply-To: <20170524003420.5381-21-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.com>

On 05/24/2017 02:34 AM, Bart Van Assche wrote:
> Just like for the scsi-mq code path, in the single queue SCSI code
> path only add commands to the per-device command list if required
> by the SCSI LLD. This patch will make it easier to merge the
> single-queue and multiqueue command initialization code.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/scsi/scsi.c      |  9 +--------
>  drivers/scsi/scsi_lib.c  | 52 +++++++++++++++++++++++++++++-------------------
>  drivers/scsi/scsi_priv.h |  2 ++
>  3 files changed, 35 insertions(+), 28 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
