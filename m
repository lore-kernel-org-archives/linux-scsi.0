From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] scsi_dh_alua: Ensure that alua_activate() calls the
 completion function
Date: Sat, 18 Mar 2017 12:19:11 +0100
Message-ID: <863138f8-3077-3989-a7b7-034d826e20e0@suse.de>
References: <20170318000203.7469-1-bart.vanassche@sandisk.com>
 <20170318000203.7469-3-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40308 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751307AbdCRLdl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 18 Mar 2017 07:33:41 -0400
In-Reply-To: <20170318000203.7469-3-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Tang Junhui <tang.junhui@zte.com.cn>, stable@vger.kernel.org

On 03/18/2017 01:02 AM, Bart Van Assche wrote:
> Callers of scsi_dh_activate(), e.g. dm-mpath, assume that this
> function either returns an error code or calls the completion
> function. Make alua_activate() call the completion function even
> if scsi_device_get() fails.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Tang Junhui <tang.junhui@zte.com.cn>
> Cc: <stable@vger.kernel.org>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
