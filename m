From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/15] hisi_sas: remove init_id_frame_v1_hw()
Date: Wed, 14 Sep 2016 14:50:44 +0200
Message-ID: <22dd5b14-a843-9522-f609-f3a1be0a563c@suse.de>
References: <1473176185-217808-1-git-send-email-john.garry@huawei.com>
 <1473176185-217808-14-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1473176185-217808-14-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On 09/06/2016 05:36 PM, John Garry wrote:
> Function config_id_frame_v1_hw() is called twice for
> each PHY during initialisation, which is unneeded.
> 
> So remove init_id_frame_v1_hw(), which only calls
> config_id_frame_v1_hw().
> 
> We will keep the call to config_id_frame_v1_hw()
> in start_phy_v1_hw() since it will be used for
> PHY reset functions.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
