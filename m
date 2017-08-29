From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 1/3] Rework the code for caching Vital Product Data
 (VPD)
Date: Tue, 29 Aug 2017 08:25:18 +0200
Message-ID: <9ec8bb8f-a0e2-fe43-f7f1-ab85882233cc@suse.de>
References: <20170828204149.28693-1-bart.vanassche@wdc.com>
 <20170828204149.28693-2-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38829 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750796AbdH2GZV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Aug 2017 02:25:21 -0400
In-Reply-To: <20170828204149.28693-2-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jthumshirn@suse.de>, Shane M Seymour <shane.seymour@hpe.com>

On 08/28/2017 10:41 PM, Bart Van Assche wrote:
> Introduce the scsi_get_vpd_buf() and scsi_update_vpd_page()
> functions. The only functional change in this patch is that if
> updating page 0x80 fails that it is attempted to update page 0x83.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> Cc: Shane M Seymour <shane.seymour@hpe.com>
> ---
>  drivers/scsi/scsi.c | 144 ++++++++++++++++++++++++----------------------------
>  1 file changed, 66 insertions(+), 78 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
