From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH][next] scsi: megaraid_sas: fix spelling mistake
 "megarid_sas" -> "megaraid_sas"
Date: Tue, 23 Jul 2019 23:47:11 +0530
Message-ID: <CAL2rwxp_MNBiouBmAEXidEVxoLmb74dZWbGTPyTazH+MRe_sFg@mail.gmail.com>
References: <20190720215840.23831-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190720215840.23831-1-colin.king@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, Jul 21, 2019 at 3:28 AM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> Fix spelling mistake in kernel warning message and replace
> printk with with pr_warn.
>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index b2339d04a700..2590746c81e3 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -8763,7 +8763,7 @@ static int __init megasas_init(void)
>
>         if ((event_log_level < MFI_EVT_CLASS_DEBUG) ||
>             (event_log_level > MFI_EVT_CLASS_DEAD)) {
> -               printk(KERN_WARNING "megarid_sas: provided event log level is out of range, setting it to default 2(CLASS_CRITICAL), permissible range is: -2 to 4\n");
> +               pr_warn("megaraid_sas: provided event log level is out of range, setting it to default 2(CLASS_CRITICAL), permissible range is: -2 to 4\n");
>                 event_log_level = MFI_EVT_CLASS_CRITICAL;
>         }
>
> --
> 2.20.1
>
