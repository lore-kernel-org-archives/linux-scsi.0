From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH] drivers: scsi: lpfc_debugfs: Fix wrong assignment
Date: Thu, 14 Nov 2013 10:41:34 -0500
Message-ID: <5284EF2E.7010600@emulex.com>
References: <1382138137-4088-1-git-send-email-felipensp@gmail.com>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:48651 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab3KNPlg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Nov 2013 10:41:36 -0500
In-Reply-To: <1382138137-4088-1-git-send-email-felipensp@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Felipe Pena <felipensp@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Thanks!

Acked-by:   James Smart  <james.smart@emulex.com>

-- james s


On 10/18/2013 7:15 PM, Felipe Pena wrote:
> On lpfc_debugfs_initialize function the dumpHostSlim member setup happens
> when 'phba->sli_rev < LPFC_SLI_REV4' is true, however when it is false NULL
> has been assigned to debug_dumpHBASlim instead of debug_dumpHostSlim.
>
> Signed-off-by: Felipe Pena <felipensp@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_debugfs.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
> index 60084e6..b800cc9 100644
> --- a/drivers/scsi/lpfc/lpfc_debugfs.c
> +++ b/drivers/scsi/lpfc/lpfc_debugfs.c
> @@ -4001,7 +4001,7 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
>   				goto debug_failed;
>   			}
>   		} else
> -			phba->debug_dumpHBASlim = NULL;
> +			phba->debug_dumpHostSlim = NULL;
>
>   		/* Setup dumpData */
>   		snprintf(name, sizeof(name), "dumpData");
> --
> 1.7.10.4
>
>
>

