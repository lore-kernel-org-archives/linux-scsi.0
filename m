From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 1/7] scsi: hisi_sas: workaround v2 hw SATA IO timeout
 issue
Date: Thu, 19 Jan 2017 09:41:49 +0100
Message-ID: <20170119084149.GE5054@linux-x5ow.site>
References: <1484757173-235951-1-git-send-email-john.garry@huawei.com>
 <1484757173-235951-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484757173-235951-2-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 19, 2017 at 12:32:47AM +0800, John Garry wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> The v2 SAS controller needs more time to detect channel idle
> and send setup link request than SATA disk does, so it is
> difficult for SAS controller to setup an STP link. Therefore it
> may cause some IO timeouts.
> 
> We need to periodically configure the SAS controller so it
> doesn't receive STP setup requests from SATA disks for a while,
> so IO can be sent during this period.
> 
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---

Looks good,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
