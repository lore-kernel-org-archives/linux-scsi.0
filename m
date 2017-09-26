From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH] scsi: ufs: fix a pclint warning
Date: Tue, 26 Sep 2017 14:42:37 -0700
Message-ID: <ae6a32f2cfd473fd29475717a9c6901f@codeaurora.org>
References: <20170919085030.125435-1-zangleigang@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54018 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032282AbdIZVmi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2017 17:42:38 -0400
In-Reply-To: <20170919085030.125435-1-zangleigang@hisilicon.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Zang Leigang <zangleigang@hisilicon.com>
Cc: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2017-09-19 01:50, Zang Leigang wrote:
> Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
> 
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 794a4600e952..deb77535b8c9 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -3586,7 +3586,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba
> *hba, struct uic_command *cmd)
>  	status = ufshcd_get_upmcrs(hba);
>  	if (status != PWR_LOCAL) {
>  		dev_err(hba->dev,
> -			"pwr ctrl cmd 0x%0x failed, host upmcrs:0x%x\n",
> +			"pwr ctrl cmd 0x%x failed, host upmcrs:0x%x\n",
>  			cmd->command, status);
>  		ret = (status != PWR_OK) ? status : -1;
>  	}


Looks good to me.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
