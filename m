From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 6/7] scsi: hisi_sas: fix probe ordering problem
Date: Thu, 19 Jan 2017 09:55:16 +0100
Message-ID: <20170119085516.GJ5054@linux-x5ow.site>
References: <1484757173-235951-1-git-send-email-john.garry@huawei.com>
 <1484757173-235951-7-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1484757173-235951-7-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Xiang Chen <chenxiang66@hisilicon.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jan 19, 2017 at 12:32:52AM +0800, John Garry wrote:
> From: Xiang Chen <chenxiang66@hisilicon.com>
> 
> There is a potential probe issue in how we trigger the hw initialisation.
> Although we use 1s timer to delay hw initialisation, there is still a
> potential that sas_register_ha() is not be finished before we start
> the PHY init from hw->hw_init().
> To avoid this issue, initialise the hw after sas_register_ha() in the
> same probe context.
> Note: it is not necessary to use 1s timer now (modified v2 hw only).
> 
> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---

Looks OK,
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
