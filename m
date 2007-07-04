From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [PATCH] lpfc: convert to use the data buffer accessors - part
 2
Date: Tue, 03 Jul 2007 22:17:23 -0400
Message-ID: <468B0333.6080000@emulex.com>
References: <468A6763.3020102@panasas.com>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:44779 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbXGDCR5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jul 2007 22:17:57 -0400
In-Reply-To: <468A6763.3020102@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi <linux-scsi@vger.kernel.org>

ACK - missed in our merge. Thank You...

-- james s

Boaz Harrosh wrote:
>  This is an addendum to:
>  commit a0b4f78f9a4c869e9b29f254054ad7441cb40bbf
>  Author: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>     [SCSI] lpfc: convert to use the data buffer accessors
> 
>  One place was missed in the merge
> 
>  Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
> ---
>  drivers/scsi/lpfc/lpfc_scsi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 5d2e3de..3d35eae 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -506,7 +506,7 @@ lpfc_handle_fcp_err(struct lpfc_vport *vport, struct lpfc_scsi_buf *lpfc_cmd,
>  					"underrun converted to error "
>  					"Data: x%x x%x x%x\n",
>  					phba->brd_no, vpi, cmnd->cmnd[0],
> -					cmnd->request_bufflen,
> +					scsi_bufflen(cmnd),
>  					scsi_get_resid(cmnd), cmnd->underflow);
>  			host_status = DID_ERROR;
>  		}
