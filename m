From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH -next] scsi: lpfc: Remove unnecessary null check before
 kfree
Date: Mon, 15 Jul 2019 07:51:30 -0700
Message-ID: <3a56b01a-27e4-6ebc-0e99-8a06a2f2f75f@broadcom.com>
References: <20190711141037.57880-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190711141037.57880-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>, dick.kennedy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 7/11/2019 7:10 AM, YueHaibing wrote:
> A null check before a kfree is redundant, so remove it.
> This is detected by coccinelle.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/scsi/lpfc/lpfc_bsg.c | 4 +---
>

Reviewed-by: James Smart <james.smart@broadcom.com>

-- james
