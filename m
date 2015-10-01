From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] phy: exynos-ufs: exynos_ufs_phy_calibrate() can be static
Date: Thu, 1 Oct 2015 19:04:30 +0800
Message-ID: <20151001110430.GA12682@athens>
References: <201510011920.tppZbk0e%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60842 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbbJALFW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Oct 2015 07:05:22 -0400
Content-Disposition: inline
In-Reply-To: <1443686970-28104-3-git-send-email-alim.akhtar@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>


Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 phy-exynos-ufs.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/phy-exynos-ufs.c b/drivers/phy/phy-exynos-ufs.c
index 343fcaf..835ee78 100644
--- a/drivers/phy/phy-exynos-ufs.c
+++ b/drivers/phy/phy-exynos-ufs.c
@@ -66,7 +66,7 @@ static bool match_cfg_to_pwr_mode(u8 desc, u8 required_pwr)
 	return false;
 }
 
-int exynos_ufs_phy_calibrate(struct phy *phy, enum phy_cfg_tag tag, u8 pwr)
+static int exynos_ufs_phy_calibrate(struct phy *phy, enum phy_cfg_tag tag, u8 pwr)
 {
 	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
 	struct exynos_ufs_phy_cfg **cfgs = ufs_phy->cfg;
@@ -93,14 +93,14 @@ out:
 	return 0;
 }
 
-void exynos_ufs_phy_set_lane_cnt(struct phy *phy, u8 lane_cnt)
+static void exynos_ufs_phy_set_lane_cnt(struct phy *phy, u8 lane_cnt)
 {
 	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
 
 	ufs_phy->lane_cnt = lane_cnt;
 }
 
-int exynos_ufs_phy_wait_for_lock_acq(struct phy *phy)
+static int exynos_ufs_phy_wait_for_lock_acq(struct phy *phy)
 {
 	struct exynos_ufs_phy *ufs_phy = get_exynos_ufs_phy(phy);
 	const unsigned int timeout_us = 100000;
