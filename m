From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH 1/3] scsi:ufs:add AHIT for hi3660 ufs
Date: Mon, 12 Jun 2017 13:50:25 -0700
Message-ID: <cb03a80c6e0621b25d9c41be4e34bf47@codeaurora.org>
References: <20170610012045.33325-1-butao@hisilicon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170610012045.33325-1-butao@hisilicon.com>
Sender: linux-kernel-owner@vger.kernel.org
To: butao <butao@hisilicon.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, guodong.xu@linaro.org, gengjianfeng@hisilicon.com, kongfei@hisilicon.com, suzhuangluan@hisilicon.com, steven.yujianfeng@hisilicon.com, zangleigang@hisilicon.com, linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 2017-06-09 18:20, butao wrote:
> add Auto-Hibernate Idle Timer value for hi3660 ufs
> 
> Signed-off-by: Bu Tao <butao@hisilicon.com>
> Signed-off-by: Geng Jianfeng <gengjianfeng@hisilicon.com>
> Signed-off-by: Zang Leigang <zangleigang@hisilicon.com>
> Signed-off-by: Yu Jianfeng <steven.yujianfeng@hisilicon.com>
> ---
>  drivers/scsi/ufs/ufshci.h | 3 +++
>  1 file changed, 3 insertions(+)
>  mode change 100644 => 100755 drivers/scsi/ufs/ufshci.h
> 
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> old mode 100644
> new mode 100755
> index f60145d4a66e..5ab9dfe4280e
> --- a/drivers/scsi/ufs/ufshci.h
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -151,6 +151,9 @@ enum {
>  				CONTROLLER_FATAL_ERROR |\
>  				SYSTEM_BUS_FATAL_ERROR)
> 
> +/* AHIT - Auto-Hibernate Idle Timer */
> +#define UFS_AHIT_AH8ITV_MASK			0x3FF

This should be added only when we would need it in the driver.

> +
>  /* HCS - Host Controller Status 30h */
>  #define DEVICE_PRESENT				UFS_BIT(0)
>  #define UTP_TRANSFER_REQ_LIST_READY		UFS_BIT(1)

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
