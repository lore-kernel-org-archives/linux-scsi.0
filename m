From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH] scsi: remove useless acpi functions in the head file
Date: Tue, 10 Jan 2017 11:44:40 +0000
Message-ID: <e1478c4b-28eb-a10b-f359-eab1f822271d@huawei.com>
References: <1484036044-9514-1-git-send-email-guohanjun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:55840 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757979AbdAJLpe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2017 06:45:34 -0500
In-Reply-To: <1484036044-9514-1-git-send-email-guohanjun@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hanjun Guo <guohanjun@huawei.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Hanjun Guo <hanjun.guo@linaro.org>, aaron.lu@intel.com

On 10/01/2017 08:14, Hanjun Guo wrote:
> From: Hanjun Guo <hanjun.guo@linaro.org>
>
> commit f1bc1e4c44b1 ("ata: acpi: rework the ata acpi bind support")
> removed scsi_register_acpi_bus_type() and scsi_unregister_acpi_bus_type(),
> but forgot to remove them in the head file, do it now.
>
> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  include/scsi/scsi.h | 10 ----------
>  1 file changed, 10 deletions(-)
>
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index 8ec7c30..a1e1930 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -29,16 +29,6 @@ enum scsi_timeouts {
>   */
>  #define SCAN_WILD_CARD	~0
>
> -#ifdef CONFIG_ACPI
> -struct acpi_bus_type;
> -
> -extern int
> -scsi_register_acpi_bus_type(struct acpi_bus_type *bus);
> -
> -extern void
> -scsi_unregister_acpi_bus_type(struct acpi_bus_type *bus);
> -#endif
> -
>  /** scsi_status_is_good - check the status return.
>   *
>   * @status: the status passed up from the driver (including host and
>

Looks ok,

Reviewed-by: John Garry <john.garry@huawei.com>

