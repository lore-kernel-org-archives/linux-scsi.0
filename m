From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH -next] scsi: lpfc: Remove set but not used variables 'qp'
Date: Tue, 4 Jun 2019 10:34:37 -0700
Message-ID: <a9496faa-6dd3-47dc-b5ba-7716c2b21940@broadcom.com>
References: <20190531152745.7928-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531152745.7928-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>, dick.kennedy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, jsmart2021@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 5/31/2019 8:27 AM, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warnings:
>
> drivers/scsi/lpfc/lpfc_init.c: In function lpfc_setup_cq_lookup:
> drivers/scsi/lpfc/lpfc_init.c:9359:30: warning: variable qp set but not used [-Wunused-but-set-variable]
>
> It's not used since commit e70596a60f88 ("scsi: lpfc: Fix
> poor use of hardware queues if fewer irq vectors")
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>

Looks good - thank You

Reviewed-by: James Smart  <james.smart@broadcom.com>
