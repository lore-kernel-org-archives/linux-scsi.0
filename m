From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v2 07/10] scsi: ufs-qcom: remove broken hci version quirk
Date: Wed, 16 May 2018 14:13:25 -0700
Message-ID: <31fe63a7a6497299dd2902fb15cc6346@codeaurora.org>
References: <cover.1525343531.git.asutoshd@codeaurora.org>
 <c20e9a0036c3f1bd0a255da9dfd092aa0fad238b.1525343531.git.asutoshd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c20e9a0036c3f1bd0a255da9dfd092aa0fad238b.1525343531.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Asutosh Das <asutoshd@codeaurora.org>
Cc: cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2018-05-03 04:07, Asutosh Das wrote:
> From: Subhash Jadavani <subhashj@codeaurora.org>
> 
> UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION is only applicable for QCOM UFS 
> host
> controller version 2.x.y and this has been fixed from version 3.x.y
> onwards, hence this change removes this quirk for version 3.x.y 
> onwards.
> 
> Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
> Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
> ---
>  drivers/scsi/ufs/ufs-qcom.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
> index d9edef8..27be327 100644
> --- a/drivers/scsi/ufs/ufs-qcom.c
> +++ b/drivers/scsi/ufs/ufs-qcom.c
> @@ -1103,7 +1103,7 @@ static void ufs_qcom_advertise_quirks(struct 
> ufs_hba *hba)
>  		hba->quirks |= UFSHCD_QUIRK_BROKEN_LCC;
>  	}
> 
> -	if (host->hw_ver.major >= 0x2) {
> +	if (host->hw_ver.major == 0x2) {
>  		hba->quirks |= UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION;
>  		hba->quirks |= UFSHCD_QUIRK_BROKEN_PWR_MODE_CHANGE;
>  		if (!ufs_qcom_cap_qunipro(host))

Looks good to me.

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
