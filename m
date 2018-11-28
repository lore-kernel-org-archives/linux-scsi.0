From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: Re: [PATCH 30/41] scsi: megaraid_sas_fusion: Mark expected switch fall-through
Date: Wed, 28 Nov 2018 12:11:12 +0530
Message-ID: <CAL2rwxo0UW1N8K4qnYaNSwW5QtyBdOMQyt8KrO58PbqMaeOdfw@mail.gmail.com>
References: <cover.1543374820.git.gustavo@embeddedor.com> <5fceeac101cc3dfe4a129764a139c1b616cba292.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5fceeac101cc3dfe4a129764a139c1b616cba292.1543374820.git.gustavo@embeddedor.com>
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
> Notice that, in this particular case, I replaced "Fall thru" with a
> "Fall through" annotation and added a dash as a token in order to
> separate the "Fall through" annotation from the rest of the comment
> on the same line, which is what GCC is expecting to find.
>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Acked-by: Sumit Saxena <sumit.saxena@broadcom.com>

> ---
>  drivers/scsi/megaraid/megaraid_sas_fusion.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> index c5e6bccb0895..8f37ad83be9a 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
> @@ -3453,7 +3453,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
>                                 atomic_dec(&lbinfo->scsi_pending_cmds[cmd_fusion->pd_r1_lb]);
>                                 cmd_fusion->scmd->SCp.Status &= ~MEGASAS_LOAD_BALANCE_FLAG;
>                         }
> -                       //Fall thru and complete IO
> +                       /* Fall through - and complete IO */
>                 case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
>                         atomic_dec(&instance->fw_outstanding);
>                         if (cmd_fusion->r1_alt_dev_handle == MR_DEVHANDLE_INVALID) {
> --
> 2.17.1
>
