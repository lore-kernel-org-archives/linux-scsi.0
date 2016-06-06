From: zhangfei <zhangfei.gao@linaro.org>
Subject: Re: [PATCH 1/3] hisi_sas: add v2 hw ACPI support
Date: Mon, 06 Jun 2016 13:24:05 +0800
Message-ID: <575508F5.10500@linaro.org>
References: <1464698331-228732-1-git-send-email-john.garry@huawei.com> <1464698331-228732-2-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1464698331-228732-2-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 05/31/2016 08:38 PM, John Garry wrote:
> Add support in v2 hw driver for ACPI.
>
> A check on whether an ACPI handle is available for the device is used to
> decide on whether to use ACPI reset handler or syscon for hw reset.
>
> Signed-off-by: John Garry <john.garry@huawei.com>
> Signed-off-by: Wei Xu <xuwei5@hisilicon.com>

Reviewed-by: Zhangfei Gao <zhangfei.gao@linaro.org>

Thanks
