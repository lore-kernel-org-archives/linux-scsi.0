From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2 09/10] scsi/ufs: qcom: Add phy_exit call in hcd exit
 path
Date: Tue, 18 Oct 2016 13:19:13 -0700
Message-ID: <1b0a9e1ebeef74f9ead7c7b71282c86d@codeaurora.org>
References: <1476800897-19898-1-git-send-email-vivek.gautam@codeaurora.org>
 <1476800897-19898-10-git-send-email-vivek.gautam@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44270 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751352AbcJRUTO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Oct 2016 16:19:14 -0400
In-Reply-To: <1476800897-19898-10-git-send-email-vivek.gautam@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vivek Gautam <vivek.gautam@codeaurora.org>
Cc: kishon@ti.com, jejb@linux.vnet.ibm.com, vinholikatti@gmail.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-scsi-owner@vger.kernel.org

On 2016-10-18 07:28, Vivek Gautam wrote:
> Do a phy_exit() over the ufs phy in the ufs qcom exit path
> to de-initialize the phy.
> 
> Signed-off-by: Vivek Gautam <vivek.gautam@codeaurora.org>
> ---
> 
> New patch added in v2 series.
> 
>  drivers/scsi/ufs/ufs-qcom.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 6e4ce5f..dfd2af8 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1272,6 +1272,7 @@ static void ufs_qcom_exit(struct ufs_hba *hba)
> 
>  	ufs_qcom_disable_lane_clks(host);
>  	phy_power_off(host->generic_phy);
> +	phy_exit(host->generic_phy);
>  }
> 
>  static int ufs_qcom_set_dme_vs_core_clk_ctrl_clear_div(struct ufs_hba 
> *hba,

LGTM.
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
