From: Fengguang Wu <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [kbuild-all] [RFC PATCH] phy: exynos-ufs:
 exynos_ufs_phy_calibrate() can be static
Date: Tue, 13 Oct 2015 20:58:44 +0800
Message-ID: <20151013125844.GA26972@wfg-t540p.sh.intel.com>
References: <201510011920.tppZbk0e%fengguang.wu@intel.com>
 <20151001110430.GA12682@athens>
 <561CED52.9010806@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <561CED52.9010806-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alim Akhtar <alim.akhtar-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, JBottomley-wo1vFcy6AUs@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kishon Vijay Abraham I <kishon-l0cyMroinI0@public.gmane.org>, amit.daniel-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, kbuild-all-JC7UmRfGjtg@public.gmane.org, vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, essuuj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Oct 13, 2015 at 05:08:58PM +0530, Alim Akhtar wrote:
> HI
> How I am support to handle this patch? Should I just fix these warnings in
> my patch or I just add this as a separate patch on the top of the series?

Alim, you can simply fold it into your patch.

Thanks,
Fengguang

> On 10/01/2015 04:34 PM, kbuild test robot wrote:
> >
> >Signed-off-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >---
> >  phy-exynos-ufs.c |    6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> >diff --git a/drivers/phy/phy-exynos-ufs.c b/drivers/phy/phy-exynos-ufs.c
> >index 343fcaf..835ee78 100644
> >--- a/drivers/phy/phy-exynos-ufs.c
> >+++ b/drivers/phy/phy-exynos-ufs.c
> >@@ -66,7 +66,7 @@ static bool match_cfg_to_pwr_mode(u8 desc, u8 required_pwr)
> >  	return false;
> >  }
> >
> >-int exynos_ufs_phy_calibrate(struct phy *phy, enum phy_cfg_tag tag, u8 pwr)
> >+static int exynos_ufs_phy_calibrate(struct phy *phy, enum phy_cfg_tag tag, u8 pwr)
> >  {
> >  	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
> >  	struct exynos_ufs_phy_cfg **cfgs = ufs_phy->cfg;
> >@@ -93,14 +93,14 @@ out:
> >  	return 0;
> >  }
> >
> >-void exynos_ufs_phy_set_lane_cnt(struct phy *phy, u8 lane_cnt)
> >+static void exynos_ufs_phy_set_lane_cnt(struct phy *phy, u8 lane_cnt)
> >  {
> >  	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
> >
> >  	ufs_phy->lane_cnt = lane_cnt;
> >  }
> >
> >-int exynos_ufs_phy_wait_for_lock_acq(struct phy *phy)
> >+static int exynos_ufs_phy_wait_for_lock_acq(struct phy *phy)
> >  {
> >  	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
> >  	const unsigned int timeout_us = 100000;
> >
> _______________________________________________
> kbuild-all mailing list
> kbuild-all-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> https://lists.01.org/mailman/listinfo/kbuild-all
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
