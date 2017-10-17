From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 3/8] nvmet/fc: Use sgl_alloc() and sgl_free()
Date: Tue, 17 Oct 2017 08:07:48 +0200
Message-ID: <97bcefd4-bff2-9b14-7981-21e238c2d2e6@suse.de>
References: <20171016224940.1332-1-bart.vanassche@wdc.com>
 <20171016224940.1332-4-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56704 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753147AbdJQGHv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Oct 2017 02:07:51 -0400
In-Reply-To: <20171016224940.1332-4-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-crypto@vger.kernel.org, Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>, James Smart <james.smart@broadcom.com>, Sagi Grimberg <sagi@grimberg.me>

On 10/17/2017 12:49 AM, Bart Van Assche wrote:
> Use the sgl_alloc() and sgl_free() functions instead of open coding
> these functions.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: James Smart <james.smart@broadcom.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> ---
>  drivers/nvme/target/Kconfig |  1 +
>  drivers/nvme/target/fc.c    | 36 ++----------------------------------
>  2 files changed, 3 insertions(+), 34 deletions(-)
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
