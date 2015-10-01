From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v3 02/13] phy: exynos-ufs: add UFS PHY driver for EXYNOS
 SoC
Date: Thu, 1 Oct 2015 19:04:30 +0800
Message-ID: <201510011920.tppZbk0e%fengguang.wu@intel.com>
References: <1443686970-28104-3-git-send-email-alim.akhtar@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443686970-28104-3-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>
List-Id: linux-scsi@vger.kernel.org

Hi Seungwon,

[auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]

reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> drivers/phy/phy-exynos-ufs.c:69:5: sparse: symbol 'exynos_ufs_phy_calibrate' was not declared. Should it be static?
>> drivers/phy/phy-exynos-ufs.c:96:6: sparse: symbol 'exynos_ufs_phy_set_lane_cnt' was not declared. Should it be static?
>> drivers/phy/phy-exynos-ufs.c:103:5: sparse: symbol 'exynos_ufs_phy_wait_for_lock_acq' was not declared. Should it be static?
>> drivers/phy/phy-exynos-ufs.h:82:31: sparse: incorrect type in argument 1 (different address spaces)
   drivers/phy/phy-exynos-ufs.h:82:31:    expected struct regmap *map
   drivers/phy/phy-exynos-ufs.h:82:31:    got void [noderef] <asn:2>*reg_pmu
>> drivers/phy/phy-exynos-ufs.h:82:31: sparse: incorrect type in argument 1 (different address spaces)
   drivers/phy/phy-exynos-ufs.h:82:31:    expected struct regmap *map
   drivers/phy/phy-exynos-ufs.h:82:31:    got void [noderef] <asn:2>*reg_pmu
>> drivers/phy/phy-exynos-ufs.c:203:22: sparse: incorrect type in assignment (different address spaces)
   drivers/phy/phy-exynos-ufs.c:203:22:    expected void [noderef] <asn:2>*reg_pmu
   drivers/phy/phy-exynos-ufs.c:203:22:    got struct regmap *

Please review and possibly fold the followup patch.

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
