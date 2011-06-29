From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 05/12] bfa: Changes to support vport disable and enable
 operations.
Date: Wed, 29 Jun 2011 15:35:46 -0500
Message-ID: <1309379746.13937.9.camel@mulgrave>
References: <1308005484-10483-1-git-send-email-kgudipat@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50394 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752570Ab1F2Uft (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jun 2011 16:35:49 -0400
In-Reply-To: <1308005484-10483-1-git-send-email-kgudipat@brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kgudipat@brocade.com
Cc: linux-scsi@vger.kernel.org, huangj@brocade.com, adapter_linux_open_src_team@brocade.com

On Mon, 2011-06-13 at 15:51 -0700, kgudipat@brocade.com wrote:
> diff --git a/drivers/scsi/bfa/bfi_ms.h b/drivers/scsi/bfa/bfi_ms.h
> index 0371572..d43bf6a 100644
> --- a/drivers/scsi/bfa/bfi_ms.h
> +++ b/drivers/scsi/bfa/bfi_ms.h
> @@ -72,12 +72,12 @@ struct bfi_iocfc_bootwwns {
>   * Queue configuration response from firmware
>   */
>  struct bfi_iocfc_qreg_s {
> -       u32     cpe_q_ci_off[ BFI_IOC_MAX_CQS ];
> -       u32     cpe_q_pi_off[ BFI_IOC_MAX_CQS ];
> -       u32     cpe_qctl_off[ BFI_IOC_MAX_CQS ];
> -       u32     rme_q_ci_off[ BFI_IOC_MAX_CQS ];
> -       u32     rme_q_pi_off[ BFI_IOC_MAX_CQS ];
> -       u32     rme_qctl_off[ BFI_IOC_MAX_CQS ];
> +       u32     cpe_q_ci_off[BFI_IOC_MAX_CQS];
> +       u32     cpe_q_pi_off[BFI_IOC_MAX_CQS];
> +       u32     cpe_qctl_off[BFI_IOC_MAX_CQS];
> +       u32     rme_q_ci_off[BFI_IOC_MAX_CQS];
> +       u32     rme_q_pi_off[BFI_IOC_MAX_CQS];
> +       u32     rme_qctl_off[BFI_IOC_MAX_CQS];
>  };

Next time, don't try to correct style cockups introduced in one patch in
a subsequent one ... just fix it in the actual patch.  I've done it this
time, but I'll kick the series back next time.

James


