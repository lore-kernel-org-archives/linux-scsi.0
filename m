From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 1/7] mpt3sas: Add ioc_<level> logging macros
Date: Thu, 4 Oct 2018 15:55:46 +0530
Message-ID: <CA+RiK66XNWSXWFGQ7iq4efZVMyPg_uD7ovEgqagXR+abv4=+0w@mail.gmail.com>
References: <cover.1537183087.git.joe@perches.com> <850f37801648df45486d13ff9c11574701f01471.1537183087.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <850f37801648df45486d13ff9c11574701f01471.1537183087.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: joe@perches.com
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,
Please consider this patch as Acked-by: Suganath Prabu
<suganath-prabu.subramani@broadcom.com>

Thanks.
On Mon, Sep 17, 2018 at 8:31 PM Joe Perches <joe@perches.com> wrote:
>
> These macros can help identify specific logging uses and eventually
> perhaps reduce object sizes.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index 96dc15e90bd8..941a4faf20be 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -160,6 +160,15 @@ struct mpt3sas_nvme_cmd {
>   */
>  #define MPT3SAS_FMT                    "%s: "
>
> +#define ioc_err(ioc, fmt, ...)                                         \
> +       pr_err("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
> +#define ioc_notice(ioc, fmt, ...)                                      \
> +       pr_notice("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
> +#define ioc_warn(ioc, fmt, ...)                                                \
> +       pr_warn("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
> +#define ioc_info(ioc, fmt, ...)                                                \
> +       pr_info("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
> +
>  /*
>   *  WarpDrive Specific Log codes
>   */
> --
> 2.15.0
>
