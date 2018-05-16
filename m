From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2 02/10] scsi: ufs-qcom: Enable
 UFSHCD_QUIRK_BROKEN_PWR_MODE_CHANGE quirk
Date: Wed, 16 May 2018 14:10:51 -0700
Message-ID: <c9c320de2d571663fbfd96fbb858b2b5@codeaurora.org>
References: <cover.1525343531.git.asutoshd@codeaurora.org>
 <e81a03ffb59d1f9155e26dd1d71ec495811c2937.1525343531.git.asutoshd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e81a03ffb59d1f9155e26dd1d71ec495811c2937.1525343531.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Asutosh Das <asutoshd@codeaurora.org>
Cc: cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-05-03 04:07, Asutosh Das wrote:
> Enable UFSHCD_QUIRK_BROKEN_PWR_MODE_CHANGE quirk to avoid failures
> in seen on some UFS devices.
> 
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index 4563d2e..d9edef8 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1105,7 +1105,7 @@ static void ufs_qcom_advertise_quirks(struct 
> ufs_hba *hba)
> 
>  	if (host->hw_ver.major >= 0x2) {
>  		hba->quirks |= UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION;
> -
> +		hba->quirks |= UFSHCD_QUIRK_BROKEN_PWR_MODE_CHANGE;
>  		if (!ufs_qcom_cap_qunipro(host))
>  			/* Legacy UniPro mode still need following quirks */
>  			hba->quirks |= (UFSHCD_QUIRK_DELAY_BEFORE_DME_CMDS

We may not need this.

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
