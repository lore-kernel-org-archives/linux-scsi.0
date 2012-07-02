From: Vinayak Holikatti <vinholikatti@gmail.com>
Subject: [PATCH 0/4] ufshcd: Adds glue drivers to ufshcd
Date: Mon,  2 Jul 2012 20:02:48 +0530
Message-ID: <1341239572-7408-1-git-send-email-vinholikatti@gmail.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, santoshsy@gmail.com, arnd@linaro.org, girish.shivananjappa@linaro.org, saugata.das@linaro.org, vishak.g@samsung.com, venkat@linaro.org, k.rajesh@samsung.com, yejin.moon@samsung.com, dsaxena@linaro.org, ilho215.lee@samsung.com, nala.la@samsung.com, stephen.doel@linaro.org, sreekumar.c@samsung.com, Vinayak Holikatti <vinholikatti@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch set adds following features
 - Seprates PCI glue layer from ufshcd.c into ufshcd-pci.c
 - Adds Platform glue driver ufshcd-pltfrm.c
 - Adds AMBA Primecell support with ufshcd-amba.c
 - Update correct transfer size in Command UPIU

Vinayak Holikatti (4):
  [SCSI] ufs: Separate PCI glue driver for ufshcd
  [SCSI] ufs: Add Platform glue driver for ufshcd
  [SCSI] ufs: Add AMBA glue driver to ufshcd
  [SCSI] ufs: Correct the expected data transfer size in UPIU

 drivers/scsi/ufs/Kconfig         |   47 ++++-
 drivers/scsi/ufs/Makefile        |    3 +
 drivers/scsi/ufs/ufshcd-amba.c   |  180 ++++++++++++++++
 drivers/scsi/ufs/ufshcd-pci.c    |  227 ++++++++++++++++++++
 drivers/scsi/ufs/ufshcd-pltfrm.c |  212 +++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c        |  422 ++++++--------------------------------
 drivers/scsi/ufs/ufshcd.h        |  206 +++++++++++++++++++
 drivers/scsi/ufs/ufshcd_common.h |   53 +++++
 8 files changed, 993 insertions(+), 357 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-amba.c
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.c
 create mode 100644 drivers/scsi/ufs/ufshcd.h
 create mode 100644 drivers/scsi/ufs/ufshcd_common.h

-- 
1.7.5.4
