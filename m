From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 7/7] mpt3sas: Remove unused macro MPT3SAS_FMT
Date: Thu, 4 Oct 2018 16:00:34 +0530
Message-ID: <CA+RiK66FZfZ-PXY0MddAr=6oKYfNkXHs-sNZ5BuCkQyxDTRNLQ@mail.gmail.com>
References: <cover.1537183087.git.joe@perches.com> <b2223bcc61daab4132ece3867cb93ee0426707dd.1537183088.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <b2223bcc61daab4132ece3867cb93ee0426707dd.1537183088.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
To: joe@perches.com
Cc: Sathya Prakash <sathya.prakash@broadcom.com>, jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,
Please consider this patch as Acked-by: Suganath Prabu
<suganath-prabu.subramani@broadcom.com>

Thanks.
On Mon, Sep 17, 2018 at 8:33 PM Joe Perches <joe@perches.com> wrote:
>
> All the uses have been removed, delete the macro.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.h | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index 941a4faf20be..8f1d6b071b39 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -158,8 +158,6 @@ struct mpt3sas_nvme_cmd {
>  /*
>   * logging format
>   */
> -#define MPT3SAS_FMT                    "%s: "
> -
>  #define ioc_err(ioc, fmt, ...)                                         \
>         pr_err("%s: " fmt, (ioc)->name, ##__VA_ARGS__)
>  #define ioc_notice(ioc, fmt, ...)                                      \
> --
> 2.15.0
>
