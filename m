From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 15/15] hisi_sas: send three identify before phy up
Date: Wed, 14 Sep 2016 14:52:08 +0200
Message-ID: <6aff1701-555e-7ebd-e503-73659c68702e@suse.de>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
 <1473176185-217808-16-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55263 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756072AbcINMwN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Sep 2016 08:52:13 -0400
In-Reply-To: <1473176185-217808-16-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, NengLong Zhao <zhaonenglong@hisilicon.com>

On 09/06/2016 05:36 PM, John Garry wrote:
> When the v2 hw is attached with many disks through
> an expander, there may be OOB reset resulting in a PHY
> going down after the speed is negotiated (very low
> probability).
> 
> This issue is resolved by modifying the link control
> registers to send three identify frames before the PHY
> is ready (according to 6.10.3.3.2 in SAS 3.0 spec) and
> close ready when the PHY is down.
> 
> Signed-off-by: NengLong Zhao <zhaonenglong@hisilicon.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 20 ++++++++++++++++----
>  1 file changed, 16 insertions(+), 4 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
