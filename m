From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v2 1/8] hisi_sas: add internal abort main code
Date: Wed, 24 Aug 2016 14:41:33 +0200
Message-ID: <2bc83181-1cd8-ff92-4961-62a21e73a6e7@suse.de>
References: <1472036754-156813-1-git-send-email-john.garry@huawei.com>
 <1472036754-156813-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1472036754-156813-2-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 08/24/2016 01:05 PM, John Garry wrote:
> Add main code for internal abort functionality.
> 
> The internal abort features allows the host controller
> to abort commands which are still active in the
> controller but have not yet been sent to the slave
> device.
> 
> Typically a command only spends a relatively
> short time in the controller when compared to the
> amount of the time after it is sent to the slave
> device.
> Two modes of internal abort are supported:
> - device
> - individual command
> 
> For device, when the internal abort is issued all
> commands in the host for that device are aborted.
> For a single command, only that command is aborted
> if it is still in the host.
> 
> In HW the internal abort command is executed
> similar to any other sort of command, like SSP.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/hisi_sas/hisi_sas.h      |   8 ++
>  drivers/scsi/hisi_sas/hisi_sas_main.c | 163 ++++++++++++++++++++++++++++++++++
>  2 files changed, 171 insertions(+)
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
