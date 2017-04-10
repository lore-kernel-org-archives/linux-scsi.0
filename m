From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/6] scsi: hisi_sas: workaround a SoC SATA IO processing
 bug
Date: Mon, 10 Apr 2017 16:07:00 +0200
Message-ID: <20170410140700.GT1978@linux-x5ow.site>
References: <1491830521-21437-1-git-send-email-john.garry@huawei.com>
 <1491830521-21437-3-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1491830521-21437-3-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, zhangfei.gao@linaro.org, Xiaofei Tan <tanxiaofei@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 10, 2017 at 09:21:57PM +0800, John Garry wrote:
> From: Xiaofei Tan <tanxiaofei@huawei.com>
> 
> This patch provides a workaround a SoC bug where SATA IPTTs for
> different devices may conflict.
> 
> The workaround solution requests the following:
> 1. SATA device id must be even and not equal to SAS IPTT.
> 2. SATA device can not share the same IPTT with other SAS or
> SATA device.
> 
> Besides we shall consider IPTT value 0 is reserved for another SoC
> bug (STP device open link at firstly after SAS controller reset).
> 
> To sum up, the solution is:
> Each SATA device uses independent and continuous 32 even IPTT from
> 64 to 4094, then v2 hw can only support 63 SATA devices.
> All SAS device(SSP/SMP devices) share odd IPTT value from 1 to
> 4095.
> 
> Signed-off-by: Xiaofei Tan <tanxiaofei@huawei.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
