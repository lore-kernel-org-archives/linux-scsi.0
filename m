From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 09/16] block: add reference counting for struct bsg_job
Date: Thu, 13 Oct 2016 13:43:01 +0200
Message-ID: <562205dc-79ba-66f5-17ed-221559fb6a9a@suse.de>
References: <cover.1476276823.git.jthumshirn@suse.de>
 <d24033462e3d6e65459db163330a8186c7e14c0a.1476276823.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55483 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754539AbcJMLnD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 07:43:03 -0400
In-Reply-To: <d24033462e3d6e65459db163330a8186c7e14c0a.1476276823.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>

On 10/12/2016 03:06 PM, Johannes Thumshirn wrote:
> Add reference counting to 'struct bsg_job' so we can implement a reuqest
> timeout handler for bsg_jobs, which is needed for Fibre Channel.
> 
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  block/bsg-lib.c         | 7 +++++--
>  include/linux/bsg-lib.h | 2 ++
>  2 files changed, 7 insertions(+), 2 deletions(-)
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
