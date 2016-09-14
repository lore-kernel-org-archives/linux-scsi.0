From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/15] hisi_sas: save completion queue read pointer
Date: Wed, 14 Sep 2016 13:46:32 +0200
Message-ID: <b0871288-f2b4-1f73-85bb-28f7b6ad250c@suse.de>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
 <1473176185-217808-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473176185-217808-2-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/06/2016 05:36 PM, John Garry wrote:
> Optimise by saving an avoidable read in the cq
> interrupt.
> The queue read pointer will only be updated
> by software, so don't bother re-reading
> what was already written in the previous interrupt.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas.h       | 1 +
>  drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 6 ++----
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 5 ++---
>  3 files changed, 5 insertions(+), 7 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
