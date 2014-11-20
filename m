From: merez@codeaurora.org
Subject: Re: [PATCH 0/6] various fixes for UFS-PM series
Date: Thu, 20 Nov 2014 11:42:01 -0000
Message-ID: <3e1028b6661b84e7aed555863e098e67.squirrel@www.codeaurora.org>
References: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
Cc: james.bottomley@hansenpartnership.com, hch@infradead.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

Reviewed-by: Maya Erez <merez@codeaurora.org>

> Contains a couple of bug fixes reported by Akinobu Mita, In adition to
> "static checker" warnings reported by Dan Carpenter.
>
> Akinobu Mita (1):
>   scsi: ufs: fix reference counting of W-LUs
>
> Dolev Raviv (4):
>   scsi: ufs: fix static checker errors in ufshcd_system_suspend
>   scsi: ufs: fix static checker warning in ufshcd_populate_vreg
>   scsi: ufs: fix static checker warning in __ufshcd_setup_clocks
>   scsi: ufs: fix static checker warning in ufshcd_parse_clock_info
>
> Yaniv Gardi (1):
>   scsi: ufs: fix power info after link start-up
>
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 15 +++----
>  drivers/scsi/ufs/ufshcd.c        | 96
> +++++++++++++++++++++++-----------------
>  drivers/scsi/ufs/ufshcd.h        |  2 -
>  3 files changed, 61 insertions(+), 52 deletions(-)
>
> --
> 1.8.5.2
> --
> Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux
> Foundation Collaborative Project
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Maya Erez
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
Collaborative Project
