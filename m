From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 02/15] hisi_sas: save delivery queue write pointer
Date: Wed, 14 Sep 2016 13:47:35 +0200
Message-ID: <30d2ed09-d8b5-ef52-0bf5-847b4171e99c@suse.de>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
 <1473176185-217808-3-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473176185-217808-3-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 09/06/2016 05:36 PM, John Garry wrote:
> Optimise by saving an avoidable read in the
> get_free_slot function.
> The delivery queue write pointer will only be
> updated by software, so don't bother re-reading
> what was already written in the previous call
> to start_delivery function.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas.h       |  7 +++++++
>  drivers/scsi/hisi_sas/hisi_sas_main.c  |  5 +++++
>  drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 12 +++++++-----
>  drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  9 ++++++---
>  4 files changed, 25 insertions(+), 8 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Cheers
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
