From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [RFC PATCH] phy: exynos-ufs: exynos_ufs_phy_calibrate() can be
 static
Date: Tue, 13 Oct 2015 17:08:58 +0530
Message-ID: <561CED52.9010806@samsung.com>
References: <201510011920.tppZbk0e%fengguang.wu@intel.com>
 <20151001110430.GA12682@athens>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20151001110430.GA12682@athens>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
List-Id: linux-scsi@vger.kernel.org

HI
How I am support to handle this patch? Should I just fix these warnings 
in my patch or I just add this as a separate patch on the top of the series?


On 10/01/2015 04:34 PM, kbuild test robot wrote:
>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>   phy-exynos-ufs.c |    6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/phy/phy-exynos-ufs.c b/drivers/phy/phy-exynos-ufs.c
> index 343fcaf..835ee78 100644
> --- a/drivers/phy/phy-exynos-ufs.c
> +++ b/drivers/phy/phy-exynos-ufs.c
> @@ -66,7 +66,7 @@ static bool match_cfg_to_pwr_mode(u8 desc, u8 required_pwr)
>   	return false;
>   }
>
> -int exynos_ufs_phy_calibrate(struct phy *phy, enum phy_cfg_tag tag, u8 pwr)
> +static int exynos_ufs_phy_calibrate(struct phy *phy, enum phy_cfg_tag tag, u8 pwr)
>   {
>   	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
>   	struct exynos_ufs_phy_cfg **cfgs = ufs_phy->cfg;
> @@ -93,14 +93,14 @@ out:
>   	return 0;
>   }
>
> -void exynos_ufs_phy_set_lane_cnt(struct phy *phy, u8 lane_cnt)
> +static void exynos_ufs_phy_set_lane_cnt(struct phy *phy, u8 lane_cnt)
>   {
>   	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
>
>   	ufs_phy->lane_cnt = lane_cnt;
>   }
>
> -int exynos_ufs_phy_wait_for_lock_acq(struct phy *phy)
> +static int exynos_ufs_phy_wait_for_lock_acq(struct phy *phy)
>   {
>   	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
>   	const unsigned int timeout_us = 100000;
>
