From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] Fix few small typos in lpfc_scsi.c
Date: Sun, 25 Sep 2016 14:44:50 -0400 (EDT)
Message-ID: <480447687.1187225.1474829090208.JavaMail.zimbra@redhat.com>
References: <33fbff46-9dad-9ae7-e08e-5fc0ec2c890f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx5-phx2.redhat.com ([209.132.183.37]:36107 "EHLO
        mx5-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753563AbcIYSox (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Sep 2016 14:44:53 -0400
In-Reply-To: <33fbff46-9dad-9ae7-e08e-5fc0ec2c890f@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mgandhi@redhat.com
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, james smart <james.smart@avagotech.com>, dick kennedy <dick.kennedy@avagotech.com>



----- Original Message -----
> From: "Milan P. Gandhi" <mgandhi@redhat.com>
> To: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org, "james smart" <james.smart@avagotech.com>, "dick
> kennedy" <dick.kennedy@avagotech.com>
> Sent: Sunday, September 25, 2016 11:58:41 AM
> Subject: [PATCH] Fix few small typos in lpfc_scsi.c
> 
> This patch does a cleanup and fixes few small typos in lpfc_scsi.c
> 
> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> ---
>  
>  drivers/scsi/lpfc/lpfc_scsi.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index d197aa1..ca56f28 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -607,7 +607,7 @@ lpfc_sli4_fcp_xri_aborted(struct lpfc_hba *phba,
>  }
>  
>  /**
> - * lpfc_sli4_post_scsi_sgl_list - Psot blocks of scsi buffer sgls from a
> list
> + * lpfc_sli4_post_scsi_sgl_list - Post blocks of scsi buffer sgls from a
> list
>   * @phba: pointer to lpfc hba data structure.
>   * @post_sblist: pointer to the scsi buffer list.
>   *
> @@ -736,7 +736,7 @@ lpfc_sli4_post_scsi_sgl_list(struct lpfc_hba *phba,
>  }
>  
>  /**
> - * lpfc_sli4_repost_scsi_sgl_list - Repsot all the allocated scsi buffer
> sgls
> + * lpfc_sli4_repost_scsi_sgl_list - Repost all the allocated scsi buffer
> sgls
>   * @phba: pointer to lpfc hba data structure.
>   *
>   * This routine walks the list of scsi buffers that have been allocated and
> @@ -857,7 +857,7 @@ lpfc_new_scsi_buf_s4(struct lpfc_vport *vport, int
> num_to_alloc)
>  				psb->data, psb->dma_handle);
>  			kfree(psb);
>  			lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
> -					"3368 Failed to allocated IOTAG for"
> +					"3368 Failed to allocate IOTAG for"
>  					" XRI:0x%x\n", lxri);
>  			lpfc_sli4_free_xri(phba, lxri);
>  			break;
> @@ -1136,7 +1136,7 @@ lpfc_release_scsi_buf(struct lpfc_hba *phba, struct
> lpfc_scsi_buf *psb)
>   *
>   * This routine does the pci dma mapping for scatter-gather list of scsi
>   cmnd
>   * field of @lpfc_cmd for device with SLI-3 interface spec. This routine
>   scans
> - * through sg elements and format the bdea. This routine also initializes
> all
> + * through sg elements and format the bde. This routine also initializes all
>   * IOCB fields which are dependent on scsi command request buffer.
>   *
>   * Return codes:
> @@ -1269,13 +1269,16 @@ lpfc_scsi_prep_dma_buf_s3(struct lpfc_hba *phba,
> struct lpfc_scsi_buf *lpfc_cmd)
>  
>  #ifdef CONFIG_SCSI_LPFC_DEBUG_FS
>  
> -/* Return if if error injection is detected by Initiator */
> +/* Return BG_ERR_INIT if error injection is detected by Initiator */
>  #define BG_ERR_INIT	0x1
> -/* Return if if error injection is detected by Target */
> +/* Return BG_ERR_TGT if error injection is detected by Target */
>  #define BG_ERR_TGT	0x2
> -/* Return if if swapping CSUM<-->CRC is required for error injection */
> +/* Return BG_ERR_SWAP if swapping CSUM<-->CRC is required for error
> injection */
>  #define BG_ERR_SWAP	0x10
> -/* Return if disabling Guard/Ref/App checking is required for error
> injection */
> +/**
> + * Return BG_ERR_CHECK if disabling Guard/Ref/App checking is required for
> + * error injection
> + **/
>  #define BG_ERR_CHECK	0x20
>  
>  /**
> @@ -4822,7 +4825,7 @@ wait_for_cmpl:
>  		ret = FAILED;
>  		lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
>  				 "0748 abort handler timed out waiting "
> -				 "for abortng I/O (xri:x%x) to complete: "
> +				 "for aborting I/O (xri:x%x) to complete: "
>  				 "ret %#x, ID %d, LUN %llu\n",
>  				 iocb->sli4_xritag, ret,
>  				 cmnd->device->id, cmnd->device->lun);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Looks good to me
Reviewed-by Laurence Oberman <loberman@redhat.com>
