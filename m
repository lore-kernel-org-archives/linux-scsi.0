From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH -next] scsi: megaraid_sas: Make some symbols static
Date: Thu, 4 Jul 2019 14:56:12 +0530
Message-ID: <CAL2rwxoLJ-1onwPPJKcQv5L=eGGi6+zUW3vtx0Cwx9peg+NAqA@mail.gmail.com>
References: <20190702130114.29356-1-yuehaibing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190702130114.29356-1-yuehaibing@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: YueHaibing <yuehaibing@huawei.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jul 2, 2019 at 6:34 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> Fix sparse warnings:
>
> drivers/scsi/megaraid/megaraid_sas_base.c:271:1: warning: symbol 'megasas_issue_dcmd' was not declared. Should it be static?
> drivers/scsi/megaraid/megaraid_sas_base.c:2227:6: warning: symbol 'megasas_do_ocr' was not declared. Should it be static?
> drivers/scsi/megaraid/megaraid_sas_base.c:3194:25: warning: symbol 'megaraid_host_attrs' was not declared. Should it be static?
>
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index 80ab970..49e0f3d 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -280,7 +280,7 @@ void megasas_set_dma_settings(struct megasas_instance *instance,
>         }
>  }
>
> -void
> +static void
>  megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
>  {
>         instance->instancet->fire_cmd(instance,
> @@ -2237,7 +2237,7 @@ megasas_internal_reset_defer_cmds(struct megasas_instance *instance);
>  static void
>  process_fw_state_change_wq(struct work_struct *work);
>
> -void megasas_do_ocr(struct megasas_instance *instance)
> +static void megasas_do_ocr(struct megasas_instance *instance)
>  {
>         if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS1064R) ||
>         (instance->pdev->device == PCI_DEVICE_ID_DELL_PERC5) ||
> @@ -3303,7 +3303,7 @@ static DEVICE_ATTR_RO(fw_cmds_outstanding);
>  static DEVICE_ATTR_RO(dump_system_regs);
>  static DEVICE_ATTR_RO(raid_map_id);
>
> -struct device_attribute *megaraid_host_attrs[] = {
> +static struct device_attribute *megaraid_host_attrs[] = {
>         &dev_attr_fw_crash_buffer_size,
>         &dev_attr_fw_crash_buffer,
>         &dev_attr_fw_crash_state,
> --
> 2.7.4
>
>
