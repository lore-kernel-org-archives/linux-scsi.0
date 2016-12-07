From: zhangfei <zhangfei.gao@linaro.org>
Subject: Re: [PATCH] scsi: hisi_sas: support deferred probe for v2 hw
Date: Wed, 7 Dec 2016 13:57:32 +0800
Message-ID: <4acc0b8d-f8d3-4649-87aa-4059105ebf2b@linaro.org>
References: <1481028247-196779-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1481028247-196779-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 2016年12月06日 20:44, John Garry wrote:
> In the hip06 and hip07 SoCs, the interrupt lines from the
> SAS controllers are connected to mbigen hw module [1].
> The mbigen module is probed with module_init, and, as such,
> is not guaranteed to probe before the SAS driver. So we need
> to support deferred probe.
>
> We check for probe deferral in the hw layer probe, so we not
> probe into the main layer and allocate shost, memories, etc.,
> to later learn that we need to defer the probe.
>
> [1] ./Documentation/devicetree/bindings/interrupt-controller/hisilicon,mbigen-v2.txt
>
> Signed-off-by: John Garry <john.garry@huawei.com>
Reviewed-by: Zhangfei Gao <zhangfei.gao@linaro.org>

Thanks
