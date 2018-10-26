From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH -next] scsi: hisi_sas: Remove set but not used variable
 'dq_list'
Date: Fri, 26 Oct 2018 09:17:38 +0100
Message-ID: <c88cf61a-7798-0616-7cc6-4ae704402ef3@huawei.com>
References: <20181026070731.20024-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181026070731.20024-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 26/10/2018 08:07, YueHaibing wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
>
> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c: In function 'start_delivery_v1_hw':
> drivers/scsi/hisi_sas/hisi_sas_v1_hw.c:907:20: warning:
>  variable 'dq_list' set but not used [-Wunused-but-set-variable]
>
> drivers/scsi/hisi_sas/hisi_sas_v2_hw.c: In function 'start_delivery_v2_hw':
> drivers/scsi/hisi_sas/hisi_sas_v2_hw.c:1671:20: warning:
>  variable 'dq_list' set but not used [-Wunused-but-set-variable]
>
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function 'start_delivery_v3_hw':
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:889:20: warning:
>  variable 'dq_list' set but not used [-Wunused-but-set-variable]
>
> It never used since introduction in commit
> fa222db0b036 ("scsi: hisi_sas: Don't lock DQ for complete task sending")
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: John Garry <john.garry@huawei.com>
