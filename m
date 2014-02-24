From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH] [SCSI] lpfc 8.3.43: use NULL instead of 0 for pointer
Date: Mon, 24 Feb 2014 12:37:49 -0500
Message-ID: <530B836D.6000508@emulex.com>
References: <1790992.BDi3De8mQ2@daeseok-laptop.cloud.net>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1790992.BDi3De8mQ2@daeseok-laptop.cloud.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: JBottomley@parallels.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Acked-by: James Smart   <james.smart@emulex.com>

-- james s



On 2/20/2014 8:10 PM, Daeseok Youn wrote:
> >From 9e7478f6e953fac5b2bef0f5abe76fe8dc9e59d1 Mon Sep 17 00:00:00 2001
> From: Daeseok Youn <daeseok.youn@gmail.com>
> Date: Fri, 21 Feb 2014 09:03:32 +0900
> Subject: [PATCH] [SCSI] lpfc 8.3.43: use NULL instead of 0 for pointer
>
> sparse says:
> drivers/scsi/lpfc/lpfc_sli.c:16547:37: warning:
>   Using plain integer as NULL pointer
>
> Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
> ---
>   drivers/scsi/lpfc/lpfc_sli.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 8f580fd..a218ecd 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -16544,7 +16544,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
>   {
>   	LIST_HEAD(completions);
>   	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
> -	struct lpfc_iocbq *piocbq = 0;
> +	struct lpfc_iocbq *piocbq = NULL;
>   	unsigned long iflags = 0;
>   	char *fail_msg = NULL;
>   	struct lpfc_sglq *sglq;
