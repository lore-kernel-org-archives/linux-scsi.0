From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH 27/41] scsi: lpfc: lpfc_scsi: Mark expected switch
 fall-throughs
Date: Wed, 19 Dec 2018 16:28:02 -0600
Message-ID: <a0d88f0a-bd1b-41aa-d325-dbfa1e217b23@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
 <4c7efa89883829e21a09e558139e5d8a0d94dee0.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4c7efa89883829e21a09e558139e5d8a0d94dee0.1543374820.git.gustavo@embeddedor.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@broadcom.com>, Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi,

Friendly ping:

Who can ack or review this patch, please?

Thanks
-- 
Gustavo

On 11/27/18 10:32 PM, Gustavo A. R. Silva wrote:
> In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> where we are expecting to fall through.
> 
> Notice that, in this particular case, I replaced "Drop thru" with
> "fall through" annotations, which is what GCC is expecting to find.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index baed2b891efb..0eeed6c4c2ee 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -1427,7 +1427,7 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
>   
>   					break;
>   				}
> -				/* Drop thru */
> +				/* fall through */
>   			case SCSI_PROT_WRITE_INSERT:
>   				/*
>   				 * For WRITE_INSERT, force the error
> @@ -1546,7 +1546,7 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
>   					rc = BG_ERR_TGT | BG_ERR_CHECK;
>   					break;
>   				}
> -				/* Drop thru */
> +				/* fall through */
>   			case SCSI_PROT_WRITE_INSERT:
>   				/*
>   				 * For WRITE_INSERT, force the
> @@ -1628,7 +1628,7 @@ lpfc_bg_err_inject(struct lpfc_hba *phba, struct scsi_cmnd *sc,
>   			switch (op) {
>   			case SCSI_PROT_WRITE_PASS:
>   				rc = BG_ERR_CHECK;
> -				/* Drop thru */
> +				/* fall through */
>   
>   			case SCSI_PROT_WRITE_INSERT:
>   				/*
> @@ -4115,7 +4115,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
>   					lpfc_cmd->cur_iocbq.sli4_lxritag,
>   					0, 0);
>   			}
> -		/* else: fall through */
> +			/* fall through */
>   		default:
>   			cmd->result = DID_ERROR << 16;
>   			break;
> 
