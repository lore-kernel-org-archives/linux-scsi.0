From: James Smart <james.smart@broadcom.com>
Subject: Re: [PATCH -next] scsi: lpfc: Make some symbols static
Date: Tue, 4 Jun 2019 10:36:55 -0700
Message-ID: <e9a78d2a-a756-c42e-0c8d-af8ebf262615@broadcom.com>
References: <20190531152841.13684-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190531152841.13684-1-yuehaibing@huawei.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>, dick.kennedy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com, jsmart2021@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 5/31/2019 8:28 AM, YueHaibing wrote:
> Fix sparse warnings:
>
> drivers/scsi/lpfc/lpfc_sli.c:115:1: warning: symbol 'lpfc_sli4_pcimem_bcopy' was not declared. Should it be static?
> drivers/scsi/lpfc/lpfc_sli.c:7854:1: warning: symbol 'lpfc_sli4_process_missed_mbox_completions' was not declared. Should it be static?
> drivers/scsi/lpfc/lpfc_nvmet.c:223:27: warning: symbol 'lpfc_nvmet_get_ctx_for_xri' was not declared. Should it be static?
> drivers/scsi/lpfc/lpfc_nvmet.c:245:27: warning: symbol 'lpfc_nvmet_get_ctx_for_oxid' was not declared. Should it be static?
> drivers/scsi/lpfc/lpfc_init.c:75:10: warning: symbol 'lpfc_present_cpu' was not declared. Should it be static?
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>   drivers/scsi/lpfc/lpfc_init.c  | 2 +-
>   drivers/scsi/lpfc/lpfc_nvmet.c | 4 ++--
>   drivers/scsi/lpfc/lpfc_sli.c   | 4 ++--
>   3 files changed, 5 insertions(+), 5 deletions(-)
>
>

Looks good - thank You

Reviewed-by: James Smart  <james.smart@broadcom.com>
