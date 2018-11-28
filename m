From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH 29/41] scsi: megaraid: megaraid_sas_base: Mark expected
 switch fall-through
Date: Wed, 28 Nov 2018 12:10:07 +0530
Message-ID: <CAL2rwxodKijDbDYEEDSn_CfdFZ3k1md7GbvoNM8Eu6SaZV=oXA@mail.gmail.com>
References: <cover.1543374820.git.gustavo@embeddedor.com> <073efb316d0acba28e6105fcd4f4d5deda2ff3f7.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <073efb316d0acba28e6105fcd4f4d5deda2ff3f7.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gustavo@embeddedor.com
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>, megaraidlinux.pdl@broadcom.com, jejb@linux.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Nov 28, 2018 at 10:02 AM Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
>
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
> index b7d3fc6fb118..9db7aebc3564 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -3281,6 +3281,7 @@ megasas_complete_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd,
>                         megasas_complete_int_cmd(instance, cmd);
>                         break;
>                 }
> +               /* fall through */
>
>         case MFI_CMD_LD_READ:
>         case MFI_CMD_LD_WRITE:
> --
> 2.17.1
>
