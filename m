From: vinholikatti@gmail.com
Subject: [PATCH V6 0/4] [SCSI] ufs: Adds glue drivers to ufshcd
Date: Tue,  5 Feb 2013 22:17:33 +0530
Message-ID: <511137ce.0657420a.5b57.ffffa7db@mx.google.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
Sender: linux-samsung-soc-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, santoshsy@gmail.com, patches@linaro.org, linux-samsung-soc@vger.kernel.org, arnd@linaro.org, saugata.das@linaro.org, venkat@linaro.org, subhashj@codeaurora.org, sthumma@codeaurora.org, vinholikatti@gmail.com
List-Id: linux-scsi@vger.kernel.org

From: Vinayak Holikatti <vinholikatti@gmail.com>

This patch set adds following features
 - Seggregate PCI specific code in ufshcd.c and corrected copyright
 - Adds PCI glue driver ufshcd-pci.c and ufshcd.c become core module
 - Adds Platform glue driver ufshcd-pltfrm.c
 - Update correct transfer size in Command UPIU

Vinayak Holikatti (4):
  [SCSI] drivers/scsi/ufs: Seggregate PCI Specific Code
  [SCSI] drivers/scsi/ufs: Separate PCI code into glue driver
  [SCSI] ufs: Add Platform glue driver for ufshcd
  [SCSI] ufs: Correct the expected data transfersize

 drivers/scsi/ufs/Kconfig         |   87 +++++---
 drivers/scsi/ufs/Makefile        |    2 +
 drivers/scsi/ufs/ufs.h           |   44 ++---
 drivers/scsi/ufs/ufshcd-pci.c    |  211 +++++++++++++++++++
 drivers/scsi/ufs/ufshcd-pltfrm.c |  217 +++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c        |  426 ++++++++------------------------------
 drivers/scsi/ufs/ufshcd.h        |  202 ++++++++++++++++++
 drivers/scsi/ufs/ufshci.h        |   44 ++---
 8 files changed, 811 insertions(+), 422 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshcd-pci.c
 create mode 100644 drivers/scsi/ufs/ufshcd-pltfrm.c
 create mode 100644 drivers/scsi/ufs/ufshcd.h

-- 
1.7.5.4
