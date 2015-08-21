From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH 00/10] exynos-ufs: add support for Exynos
Date: Fri, 21 Aug 2015 14:57:51 +0530
Message-ID: <1440149281-26336-1-git-send-email-alim.akhtar@samsung.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: vinholikatti@gmail.com, JBottomley@odin.com
List-Id: linux-scsi@vger.kernel.org

This patch-set introduces UFS (Universal Flash Storage) host support
for Samsung Exynos SoC. Mostly, it consists of UFS PHY and host specific driver.
And it also contains some quirks handling for Exynos.

Seungwon Jeon (10):
  phy: exynos-ufs: add UFS PHY driver for EXYNOS SoC
  scsi: ufs: add quirk to contain unconformable utrd field
  scsi: ufs: add quirk to fix mishandling utrlclr/utmrlclr
  scsi: ufs: add quirk not to allow reset of interrupt aggregation
  scsi: ufs: add quirk to enable host controller without hce
  scsi: ufs: add specific callback for nexus type
  scsi: ufs: add add specific callback for hibern8
  scsi: ufs: make ufshcd_config_pwr_mode of non-static func
  scsi: ufs: return value of pwr_change_notify
  scsi: ufs-exynos: add UFS host support for Exynos SoCs

 .../devicetree/bindings/phy/samsung-phy.txt        |   22 +
 .../devicetree/bindings/ufs/ufs-exynos.txt         |   92 ++
 drivers/phy/Kconfig                                |    7 +
 drivers/phy/Makefile                               |    1 +
 drivers/phy/phy-exynos-ufs.c                       |  277 +++++
 drivers/phy/phy-exynos-ufs.h                       |   73 ++
 drivers/phy/phy-exynos7-ufs.h                      |   89 ++
 drivers/scsi/ufs/Kconfig                           |   12 +
 drivers/scsi/ufs/Makefile                          |    1 +
 drivers/scsi/ufs/ufs-exynos-hw.c                   |  147 +++
 drivers/scsi/ufs/ufs-exynos-hw.h                   |   43 +
 drivers/scsi/ufs/ufs-exynos.c                      | 1175 ++++++++++++++++++++
 drivers/scsi/ufs/ufs-exynos.h                      |  463 ++++++++
 drivers/scsi/ufs/ufshcd.c                          |  196 +++-
 drivers/scsi/ufs/ufshcd.h                          |   34 +
 drivers/scsi/ufs/ufshci.h                          |   26 +-
 drivers/scsi/ufs/unipro.h                          |   47 +
 include/linux/phy/phy-exynos-ufs.h                 |  107 ++
 18 files changed, 2785 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
 create mode 100644 drivers/phy/phy-exynos-ufs.c
 create mode 100644 drivers/phy/phy-exynos-ufs.h
 create mode 100644 drivers/phy/phy-exynos7-ufs.h
 create mode 100644 drivers/scsi/ufs/ufs-exynos-hw.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos-hw.h
 create mode 100644 drivers/scsi/ufs/ufs-exynos.c
 create mode 100644 drivers/scsi/ufs/ufs-exynos.h
 create mode 100644 include/linux/phy/phy-exynos-ufs.h

-- 
1.7.10.4
